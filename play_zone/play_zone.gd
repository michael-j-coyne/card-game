class_name PlayZone extends Node

var _p1_cards: Array[Card] = []
var _p2_cards: Array[Card] = []

var _cards: Dictionary = {
	Enums.Player.P1: _p1_cards,
	Enums.Player.P2: _p2_cards
}

func _sum_cards(cards: Array[Card]) -> int:
	return cards.reduce(func(acc, card): return acc + card.get_value(), 0)

func get_score() -> Score:
	return Score.new(
		_sum_cards(get_cards(Enums.Player.P1)),
		_sum_cards(get_cards(Enums.Player.P2)))

func get_cards(player: Enums.Player) -> Array[Card]:
	assert(player in _cards)
	return _cards[player]

func add_card(card: Card, player: Enums.Player) -> void:
	get_cards(player).append(card)
