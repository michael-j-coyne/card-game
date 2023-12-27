class_name PlayZone extends Node

var _p1_cards: Array[Card] = []
var _p2_cards: Array[Card] = []

var _cards: Dictionary = {
	Enums.Player.P1: _p1_cards,
	Enums.Player.P2: _p2_cards
}

static func _sum_cards(cards: Array[Card]) -> int:
	return cards.reduce(func(acc, card): return acc + card.get_value(), 0)

func get_score() -> Score:
	return Score.new(
		_sum_cards(get_cards(Enums.Player.P1)),
		_sum_cards(get_cards(Enums.Player.P2)))

func get_cards(player: Enums.Player) -> Array[Card]:
	assert(player in _cards)
	# TODO: duplicate the cards themselves to prevent someone from modifying
	# their values
	return _cards[player].duplicate()

func add_card(card: Card, player: Enums.Player) -> void:
	assert(player in _cards)
	assert(_cards[player] is Array[Card])
	_cards[player].append(card)
