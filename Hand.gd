extends Node2D

const Card = preload('res://Card.tscn')

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

# maybe the card_spread_y and base_rotation_degrees should scale based on the value of
# calculate_card_spread_x to avoid the situation with three cards
const max_spread := 800.0
const card_spread_y:float = 50.0
const card_speed:float = 500.0
const base_rotation_degrees = 5

func calculate_card_spread_x(num_cards_in_hand: int, card_width: int) -> float:
	const overlap = 30
	# Why do we multiply by 0.25? What is 0.25?
	var spread = num_cards_in_hand * (card_width - overlap) * 0.25
	return spread if spread < max_spread else max_spread

# type annotation for card?
# what does 'hand ratio' mean exactly?
func hand_ratio(card, hand_size: int):
	if hand_size < 2: return 0.5
		
	return float(card.get_index()) / float(hand_size - 1)

func fan_cards():
	var tween = create_tween()
	tween.set_parallel(true)
	var cards_in_hand := get_children()
	var num_cards_in_hand := cards_in_hand.size()
	
	for card in cards_in_hand:
		var card_spread_x = calculate_card_spread_x(num_cards_in_hand, card.get_width())
		var pos := _compute_pos(hand_ratio(card, num_cards_in_hand), card_spread_x)
		var rotation_degrees = \
			rotation_curve.sample(hand_ratio(card, num_cards_in_hand)) * base_rotation_degrees
		
		tween.tween_property(card, "position", pos, 0.5)
		tween.tween_property(card, "rotation_degrees", rotation_degrees, 0.5)

func _process(delta:float) -> void:
	fan_cards()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		print("mouse button event at ", event.position)
		add_child(Card.instantiate())

func _compute_pos(hand_ratio : float, card_spread_x : int) -> Vector2:
	var relative_x = horizontal_spread_curve.sample(hand_ratio) * card_spread_x
	# why do I have to multiply by -1 again?
	# I do this so the curve is an upside down U instead of a regular U, but why do I need to do it?
	var relative_y = vertical_spread_curve.sample(hand_ratio) * card_spread_y * -1
	return Vector2(relative_x, relative_y)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
