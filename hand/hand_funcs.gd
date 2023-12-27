class_name HandFuncs extends Node

const horizontal_spread_curve :=  \
	preload("res://UI/resources/horizontal_card_spread_curve.tres")
const vertical_spread_curve := \
	preload("res://UI/resources/vertical_card_spread_curve.tres")

const MAX_WIDTH := 1920.0
const CARD_SPREAD_Y : float = 55.0
const CARD_OVERLAP_X := 55.0
# TODO: single point of control

# A hand width is a floating point value
# returns the total horizontal space that the hand will occupy in pixels,
# assuming no rotation of cards
static func hand_width(num_cards_in_hand: int, card_base_width: float, card_overlap: float) -> float:
	var num_overlaps = num_cards_in_hand - 1 if num_cards_in_hand > 0 else 0
	var width = num_cards_in_hand * (card_base_width) - num_overlaps * card_overlap
	
	return width if width < MAX_WIDTH else MAX_WIDTH
	
# a 'hand ratio' is a value between 0 and 1 which is related to the position of the card
# in the hand. The leftmost card receives a value of 0 and the rightmostcard receives a value
# of 1, the middle card is 0.5
static func hand_ratio(card_index: int, hand_size: int) -> float:
	if hand_size < 0:
		push_error("hand_size much be an integer >= 0")
		return 0.5
	elif card_index < 0 or card_index > hand_size - 1:
		push_error("The card_index must be in the range [0, hand_size - 1] inclusive")
		return 0.5

	if hand_size < 2: return 0.5
	
	return float(card_index) / float(hand_size - 1)

# computes the x position of the leftmost edge of a card when it is in the hand,
# relative to the center of the hand
static func relative_x(card_width: float, card_ratio: float, total_hand_width: float) -> float:
	return (total_hand_width - card_width) * card_ratio - 0.5 * total_hand_width

# a position is a two dimensional vector whose elements are floating point numbers
# computes the position that the card should be when in its default or "idle" state in the hand
static func relative_card_default_pos(card_index: int, num_cards_in_hand: int, card_base_width: float) -> Vector2:
	var ratio = hand_ratio(card_index, num_cards_in_hand)
	var total_hand_width = hand_width(num_cards_in_hand, card_base_width, CARD_OVERLAP_X)
	
	var rel_x = relative_x(card_base_width, ratio, total_hand_width)
	var rel_y = vertical_spread_curve.sample(ratio) * CARD_SPREAD_Y * -1
	
	return Vector2(rel_x, rel_y)
