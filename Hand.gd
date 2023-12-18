extends Node2D

const CardScene = preload('res://Card.tscn')

@export var horizontal_spread_curve :=  \
	preload("res://UI/resources/horizontal_card_spread_curve.tres")
@export var vertical_spread_curve := \
	preload("res://UI/resources/vertical_card_spread_curve.tres")
@export var rotation_curve := \
	preload("res://UI/resources/hand_rotation_curve.tres")

# maybe the CARD_SPREAD_Y and BASE_ROTATION_DEGREES should scale based on the value of
# _compute_card_spread_x to avoid the situation with three cards
const MAX_SPREAD := 800.0
const CARD_SPREAD_Y : float = 45.0
const BASE_ROTATION_DEGREES = 6.5
const CARD_FAN_ANIMATION_DURATION_SECONDS = 0.25
const CARD_HOVER_ANIMATION_DURATION_SECONDS = 0.125
const CARD_SPAWN_POS = Vector2(1000, 0)
const CARD_EXPANSION_FACTOR = Vector2(1.5, 1.5)
const DEFAULT_CARD_Z_INDEX = 0
const HOVERED_CARD_Z_INDEX = 1
const SPREAD_FACTOR = 0.33

var rng = RandomNumberGenerator.new()
var hovered_cards : Array[Card] = []

# Compute the horizontal space that the hand will occupy
func _compute_card_spread_x(num_cards_in_hand: int, card_width: int) -> float:
	const overlap = 30
	var spread = num_cards_in_hand * (card_width - overlap) * SPREAD_FACTOR
	return spread if spread < MAX_SPREAD else MAX_SPREAD

func get_card_spread_x(card: Card) -> float:
	return _compute_card_spread_x(get_child_count(), card.get_width())

# a 'hand ratio' is a value between 0 and 1 which is related to the position of the card
# in the hand. The leftmost card receives a value of 0 and the rightmostcard receives a value
# of 1, the middle card is 0.5
func _compute_hand_ratio(card_index: int, hand_size: int) -> float:
	if hand_size < 2: return 0.5
	return float(card_index) / float(hand_size - 1)

func get_hand_ratio(card: Card) -> float:
	return _compute_hand_ratio(card.get_index(), get_child_count())

func _fan_cards():
	if not get_children(): return
	const duration_seconds = CARD_FAN_ANIMATION_DURATION_SECONDS
	var cards_in_hand := get_children()
	var tween := create_tween()
	tween.set_parallel(true)

	for card in cards_in_hand:
		var pos := get_card_default_pos(card)
		var rotation_amt := rotation_curve.sample(get_hand_ratio(card)) * BASE_ROTATION_DEGREES
		tween.tween_property(card, "position", pos, duration_seconds)
		tween.tween_property(card, "rotation_degrees", rotation_amt, duration_seconds)

func _process(_delta : float) -> void:
	_fan_cards()
	animate_card_hover()

# This function feels overworked to me. Let's see if we can split it up.
func animate_card_hover() -> void:
	var hovered_card := get_hovered_card()
	if not hovered_card: return
	
	# This feels hacky to me... but it works for now.
	var other_cards := get_children().filter(func(card): return card != hovered_card)
	other_cards.map(scale_card_to_default_size)
	
	hovered_card.z_index = HOVERED_CARD_Z_INDEX
	const duration_seconds = CARD_HOVER_ANIMATION_DURATION_SECONDS
	
	var base_screen_size = get_viewport().content_scale_size
	var y_pos = base_screen_size.y - (0.5 * hovered_card.get_height() * CARD_EXPANSION_FACTOR.y)
	var hovered_pos = to_local(Vector2(to_global(get_card_default_pos(hovered_card)).x, y_pos))
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(hovered_card, "scale", CARD_EXPANSION_FACTOR, duration_seconds)
	tween.tween_property(hovered_card, "rotation_degrees", 0, duration_seconds)
	tween.tween_property(hovered_card, "position", hovered_pos, duration_seconds)

func scale_card_to_default_size(card: Card) -> void:
	if not card: return
	var tween = create_tween()
	tween.tween_property(card, "scale", Vector2(1, 1), CARD_HOVER_ANIMATION_DURATION_SECONDS)

# I may want to consider using an input signal instead of an entered
# / exited signal because the input signal only triggers on unhandled input
func _on_mouse_entered_card(card: Card):
	hovered_cards.append(card)

func _on_mouse_exited_card(card: Card):
	scale_card_to_default_size(card)
	card.z_index = DEFAULT_CARD_Z_INDEX
	hovered_cards.erase(card)

# sometimes this function returns nothing... How do I handle this?
# is there a way to return a maybe(Card)? What would that be called?
func get_hovered_card() -> Card:
	if not hovered_cards: return
	var highest_index = func(max, val): return val if val.get_index() > max.get_index() else max
	var rightmost_card = hovered_cards.reduce(highest_index)
	return rightmost_card

func generate_random_card() -> Card:
	var card_name := str(rng.randi_range(1,10))
	var card := CardScene.instantiate()
	card.init(card_name)
	return card

func add_card_to_hand(card: Card):
	add_child(card)
	card.position = CARD_SPAWN_POS
	card.mouse_entered.connect(_on_mouse_entered_card)
	card.mouse_exited.connect(_on_mouse_exited_card)

# this is temporary testing code
func _input(event):
	if event.is_action_pressed("ui_accept"):
		var card_to_add = generate_random_card()
		add_card_to_hand(card_to_add)

func _compute_pos(hand_ratio: float, card_spread_x: int) -> Vector2:
	var relative_x = horizontal_spread_curve.sample(hand_ratio) * card_spread_x
	var relative_y = vertical_spread_curve.sample(hand_ratio) * CARD_SPREAD_Y * -1
	return Vector2(relative_x, relative_y)

func get_card_default_pos(card: Card) -> Vector2:
	return _compute_pos(get_hand_ratio(card), get_card_spread_x(card))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
