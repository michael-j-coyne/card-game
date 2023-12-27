extends Node

var p1_cards: Array[Card] = []
var p2_cards: Array[Card] = []

var _cards: Dictionary = {
	Enums.Player.P1: p1_cards,
	Enums.Player.P2: p2_cards
}

func _get_card_arr(player: Enums.Player) -> Array[Card]:
	assert(player in _cards)
	return _cards[player]

# 
func _sum_cards(cards: Array[Card]) -> int:
	return cards.reduce(func(acc, card): return acc + card.get_value(), 0)

func get_score() -> Score:
	return Score.new(_sum_cards(p1_cards), _sum_cards(p2_cards))

func add_card(card: Card, player: Enums.Player) -> void:
	_get_card_arr(player).append(card)
