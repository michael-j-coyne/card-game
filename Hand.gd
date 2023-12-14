extends Node2D

const CardScene = preload('res://Card.tscn')

# TODO: Make cards spawn to either the left or right, where the 'deck' is located,
# currently they spawn in the middle of the hand at the hand 'origin'

# maybe store the curve somewhere and load it like 
# const height_curve := preload("res://UI/resources/height_curve.tres") as Curve
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
const ANIMATION_DURATION_SECONDS = 0.25
const CARD_SPAWN_POS = Vector2(1000, 0)

func _compute_card_spread_x(num_cards_in_hand: int, card_width: int) -> float:
	const overlap = 30
	# Why do we multiply by 0.25? What is 0.25?
	var spread = num_cards_in_hand * (card_width - overlap) * 0.25
	return spread if spread < MAX_SPREAD else MAX_SPREAD

# type annotation for card?
# a 'hand ratio' is a value between 0 and 1 which is related to the position of the card
# in the hand. The leftmost card receives a value of 0 and the rightmostcard receives a value
# of 1, the middle card is 0.5
func _hand_ratio(card, hand_size: int):
	if hand_size < 2: return 0.5
	return float(card.get_index()) / float(hand_size - 1)

func _fan_cards():
	if not get_children(): return
	
	var cards_in_hand := get_children()
	var num_cards_in_hand := cards_in_hand.size()
	var tween = create_tween()
	tween.set_parallel(true)
	
	for card in cards_in_hand:
		var ratio = _hand_ratio(card, num_cards_in_hand)
		var card_spread_x = _compute_card_spread_x(num_cards_in_hand, card.get_width())
		var pos := _compute_pos(ratio, card_spread_x)
		var rotation_amount_degrees = rotation_curve.sample(ratio) * BASE_ROTATION_DEGREES
		
		tween.tween_property(card, "position", pos, ANIMATION_DURATION_SECONDS)
		tween.tween_property(card, "rotation_degrees", rotation_amount_degrees, ANIMATION_DURATION_SECONDS)

func _process(_delta : float) -> void:
	_fan_cards()

# this is temporary testing code
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var card_to_add = CardScene.instantiate()
		add_child(card_to_add)
		card_to_add.position = CARD_SPAWN_POS

func _compute_pos(hand_ratio : float, card_spread_x : int) -> Vector2:
	var relative_x = horizontal_spread_curve.sample(hand_ratio) * card_spread_x
	# why do I have to multiply by -1 again?
	# I do this so the curve is an upside down U instead of a regular U, but why do I need to do it?
	var relative_y = vertical_spread_curve.sample(hand_ratio) * CARD_SPREAD_Y * -1
	return Vector2(relative_x, relative_y)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
