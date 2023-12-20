extends Node2D

const CardScene = preload('res://Card.tscn')

@export var horizontal_spread_curve :=  \
	preload("res://UI/resources/horizontal_card_spread_curve.tres")
@export var vertical_spread_curve := \
	preload("res://UI/resources/vertical_card_spread_curve.tres")
@export var rotation_curve := \
	preload("res://UI/resources/hand_rotation_curve.tres")

# maybe the CARD_SPREAD_Y and BASE_ROTATION_DEGREES should scale based on the value of
# _compute_hand_width to avoid the situation with three cards
const MAX_SPREAD := 800.0
const CARD_SPREAD_Y : float = 45.0
const BASE_ROTATION_DEGREES = 6.5
const CARD_FAN_ANIMATION_DURATION_SECONDS = 0.25
const CARD_HOVER_ANIMATION_DURATION_SECONDS = 0.125
const CARD_SPAWN_POS = Vector2(1000, 0)
const CARD_EXPANSION_FACTOR = Vector2(1.5, 1.5)
const DEFAULT_CARD_Z_INDEX = 0
const HOVERED_CARD_Z_INDEX = 1

var rng = RandomNumberGenerator.new()
var hovered_cards : Array[Card] = []
var selected_card = null

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
	var num_cards_in_hand = get_child_count()
	var card_width = card.size.x
	var hand_width = _compute_hand_width(num_cards_in_hand, card_width)
	var hand_ratio = _compute_hand_ratio(card.get_index(), num_cards_in_hand)
	
	return _compute_default_pos(hand_ratio, hand_width)

# I need to be careful doing something like this because scale_card_to_default_size
# tweens the "scale" property, and only one tween should be used per object's property
# so no other tween can be acting on the "scale" property of cards that are being passed
# to this func. Consider refactoring this.
func _reset_card_animation_state(uninteracted_cards):
	for card in uninteracted_cards:
		scale_card_to_default_size(card)
		card.z_index = DEFAULT_CARD_Z_INDEX

func get_uninteracted_cards():
	var filter_func
	var hovered_card = get_hovered_card()
	
	if selected_card:
		filter_func = func(card: Card): return card != selected_card
	elif hovered_card:
		filter_func = func(card: Card): return card != hovered_card
	else:
		filter_func = func(_card: Card): return true
	
	return get_children().filter(filter_func)

func _fan_cards(cards_to_fan):
	if not get_children(): return
	const duration_seconds = CARD_FAN_ANIMATION_DURATION_SECONDS
	
	var tween := create_tween()
	tween.set_parallel(true)
	
	for card in cards_to_fan:
		var hand_ratio = _compute_hand_ratio(card.get_index(), get_child_count())
		var pos := _card_default_pos(card)
		var rotation_amt := rotation_curve.sample(hand_ratio) * BASE_ROTATION_DEGREES
		tween.tween_property(card, "position", pos, duration_seconds)
		tween.tween_property(card, "rotation_degrees", rotation_amt, duration_seconds)

func _physics_process(_delta : float) -> void:
	var uninteracted_cards = get_uninteracted_cards()
	var hovered_card = get_hovered_card()
	
	_reset_card_animation_state(uninteracted_cards)
	_fan_cards(uninteracted_cards)
	
	if selected_card:
		_animate_card_hover(selected_card)
	elif hovered_card:
		_animate_card_hover(hovered_card)

# this isn't just the card hover animation, its also the card select animation (or part of it)
func _animate_card_hover(card_to_animate: Card) -> void:
	if not card_to_animate: return
	
	card_to_animate.z_index = HOVERED_CARD_Z_INDEX
	const duration_seconds = CARD_HOVER_ANIMATION_DURATION_SECONDS
	
	var base_screen_size = get_viewport().content_scale_size
	var y_pos = base_screen_size.y - (card_to_animate.get_height())
	var hovered_pos = to_local(Vector2(to_global(_card_default_pos(card_to_animate)).x, y_pos))
	hovered_pos.y += card_to_animate.get_origin_offset().y
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(card_to_animate, "scale", CARD_EXPANSION_FACTOR, duration_seconds)
	tween.tween_property(card_to_animate, "rotation_degrees", 0, duration_seconds)
	tween.tween_property(card_to_animate, "position", hovered_pos, duration_seconds)

func scale_card_to_default_size(card: Card) -> void:
	if not card: return
	var tween = create_tween()
	tween.tween_property(card, "scale", Vector2(1, 1), CARD_HOVER_ANIMATION_DURATION_SECONDS)

func _on_mouse_entered_card(card: Card):
	hovered_cards.append(card)

func _on_mouse_exited_card(card: Card):
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
	add_child(card)
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
