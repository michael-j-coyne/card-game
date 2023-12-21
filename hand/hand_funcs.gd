class_name HandFuncs extends Node

const horizontal_spread_curve :=  \
	preload("res://UI/resources/horizontal_card_spread_curve.tres")
const vertical_spread_curve := \
	preload("res://UI/resources/vertical_card_spread_curve.tres")

const MAX_SPREAD := 800.0
const CARD_SPREAD_Y : float = 45.0

# Compute the horizontal space that the hand will occupy
static func hand_width(num_cards_in_hand: int, card_width: float) -> float:
	const card_overlap = 145
	var spread = num_cards_in_hand * (card_width - card_overlap)
	return spread if spread < MAX_SPREAD else MAX_SPREAD
	
# a 'hand ratio' is a value between 0 and 1 which is related to the position of the card
# in the hand. The leftmost card receives a value of 0 and the rightmostcard receives a value
# of 1, the middle card is 0.5
static func hand_ratio(card_index: int, hand_size: int) -> float:
	if hand_size < 2: return 0.5
	return float(card_index) / float(hand_size - 1)

static func default_pos(hand_ratio: float, hand_width: float) -> Vector2:
	var relative_x = horizontal_spread_curve.sample(hand_ratio) * hand_width
	var relative_y = vertical_spread_curve.sample(hand_ratio) * CARD_SPREAD_Y * -1
	return Vector2(relative_x, relative_y)

