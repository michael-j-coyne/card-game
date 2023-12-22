class_name HandFuncs extends Node

const horizontal_spread_curve :=  \
	preload("res://UI/resources/horizontal_card_spread_curve.tres")
const vertical_spread_curve := \
	preload("res://UI/resources/vertical_card_spread_curve.tres")

const MAX_WIDTH := 1920
const CARD_SPREAD_Y : float = 45.0
const CARD_OVERLAP_X := 65.0

# return the total horizontal space that the hand will occupy (assuming no rotation of cards)
static func hand_width(num_cards_in_hand: int, card_base_width: float, card_overlap: float) -> float:
	var num_overlaps = num_cards_in_hand - 1 if num_cards_in_hand > 0 else 0
	var width = num_cards_in_hand * (card_base_width) - num_overlaps * card_overlap
	
	return width if width < MAX_WIDTH else MAX_WIDTH
	
# a 'hand ratio' is a value between 0 and 1 which is related to the position of the card
# in the hand. The leftmost card receives a value of 0 and the rightmostcard receives a value
# of 1, the middle card is 0.5
# TODO: set limit on hand size
static func hand_ratio(card_index: int, hand_size: int) -> float:
	if hand_size < 0:
		push_error("hand_size much be an integer >= 0")
		# returning -1 could potentially cause the game to crash, should I return 0.5 instead?
		# Or would I like the game to crash?
		return -1
	elif card_index < 0 or card_index > hand_size - 1:
		push_error("The card_index must be in the range [0, hand_size - 1] inclusive")
		return -1

	if hand_size < 2: return 0.5
	
	return float(card_index) / float(hand_size - 1)

# Returns the x position for the leftmost side of the playing card relative to the hand's center,
# assuming the card has not been rotated
# TODO: Set a limit on the size of the hand and change the behavior of the function accordingly
static func relative_x(card_index: int, card_base_width: float, total_hand_width: float, card_overlap) -> float:
	return (card_index * (card_base_width - card_overlap)) - (total_hand_width / 2.0)

static func relative_card_default_pos(card_index: int, num_cards_in_hand: int, card_base_width: float) -> Vector2:
	var ratio = hand_ratio(card_index, num_cards_in_hand)
	var total_hand_width = hand_width(num_cards_in_hand, card_base_width, CARD_OVERLAP_X)
	
	# How do I unit test when I'm using a resource here? What if the resource changes?
	var rel_x = relative_x(card_index, card_base_width, total_hand_width, CARD_OVERLAP_X)
	var rel_y = vertical_spread_curve.sample(ratio) * CARD_SPREAD_Y * -1
	
	return Vector2(rel_x, rel_y)
