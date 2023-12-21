class_name Hand extends Node2D

const CardScene = preload('res://Card.tscn')

@export var horizontal_spread_curve :=  \
	preload("res://UI/resources/horizontal_card_spread_curve.tres")
@export var vertical_spread_curve := \
	preload("res://UI/resources/vertical_card_spread_curve.tres")
@export var rotation_curve := \
	preload("res://UI/resources/hand_rotation_curve.tres")

const CARD_SPAWN_POS = Vector2(1000, 0)
const MAX_SPREAD := 800.0
const CARD_SPREAD_Y : float = 45.0

var rng = RandomNumberGenerator.new()
var hovered_cards : Array[Card] = []
var selected_card = null

var state: HandState
var state_factory

func _ready():
	state_factory = HandStateFactory.new()
	change_state("idle")

func animate(cards_to_animate: Array[Node]):
	state.animate(cards_to_animate)

func change_state(new_state_name):
	if state != null:
		state.queue_free()
	state = state_factory.get_state(new_state_name).new()
	state.setup(self)
	add_child(state)

func get_selected_card() -> Card:
	return selected_card

# Compute the horizontal space that the hand will occupy
func _compute_hand_width(num_cards_in_hand: int, card_width: float) -> float:
	const card_overlap = 145
	var spread = num_cards_in_hand * (card_width - card_overlap)
	return spread if spread < MAX_SPREAD else MAX_SPREAD

# a 'hand ratio' is a value between 0 and 1 which is related to the position of the card
# in the hand. The leftmost card receives a value of 0 and the rightmostcard receives a value
# of 1, the middle card is 0.5
func _compute_hand_ratio(card_index: int, hand_size: int) -> float:
	if hand_size < 2: return 0.5
	return float(card_index) / float(hand_size - 1)

func _compute_default_pos(hand_ratio: float, hand_width: float) -> Vector2:
	var relative_x = horizontal_spread_curve.sample(hand_ratio) * hand_width
	var relative_y = vertical_spread_curve.sample(hand_ratio) * CARD_SPREAD_Y * -1
	return Vector2(relative_x, relative_y)

func _card_default_pos(card: Card) -> Vector2:
	var num_cards_in_hand = get_node("Cards").get_child_count()
	var card_width = card.size.x
	var hand_width = _compute_hand_width(num_cards_in_hand, card_width)
	var hand_ratio = _compute_hand_ratio(card.get_index(), num_cards_in_hand)
	
	return _compute_default_pos(hand_ratio, hand_width)

func get_cards() -> Array[Node]:
	return get_node("Cards").get_children()

func get_idle_cards():
	if state.state_name == "hovered":
		return get_cards().filter(func(card): return card != get_hovered_card())
	else:
		return get_cards()

func _process(_delta : float) -> void:
	animate(get_cards())

func _on_mouse_entered_card(card: Card):
	if state.state_name == "idle":
		change_state("hovered")
	hovered_cards.append(card)

func _on_mouse_exited_card(card: Card):
	if state.state_name == "hovered":
		change_state("idle")
	hovered_cards.erase(card)

func _on_card_selected(card: Card):
	selected_card = card

# sometimes this function returns nothing... How do I handle this?
# is there a way to return a maybe(Card)? What would that be called?
# I found out its called an "option" type or a "maybe" type.
func get_hovered_card() -> Card:
	if not hovered_cards: return
	var highest_index = func(max_val, val):
		return val if val.get_index() > max_val.get_index() else max_val
	var rightmost_card = hovered_cards.reduce(highest_index)
	return rightmost_card

func generate_random_card() -> Card:
	var card_name := str(rng.randi_range(1,10))
	var card := CardScene.instantiate()
	card.init(card_name)
	return card

func add_card_to_hand(card: Card):
	get_node('Cards').add_child(card)
	card.position = CARD_SPAWN_POS
	card.mouse_entered_card.connect(_on_mouse_entered_card)
	card.mouse_exited_card.connect(_on_mouse_exited_card)
	card.card_selected.connect(_on_card_selected)
	
func remove_card(card: Card):
	if card == selected_card:
		selected_card = null
	hovered_cards.erase(card)
	card.queue_free()
	
# this is temporary testing code
func _input(event):
	if event.is_action_pressed("ui_accept"):
		var card_to_add = generate_random_card()
		add_card_to_hand(card_to_add)

func _on_game_backdrop_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		selected_card = null
