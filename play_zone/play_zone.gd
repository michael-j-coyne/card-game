extends Node

var p1_cards: Array[Card] = []
var p2_cards: Array[Card] = []

func _calculate_score(cards: Array[Card]) -> int:
	return cards.reduce(func(acc, card): return acc + card.get_value(), 0)

func get_score() -> Score:
	return Score.new(_calculate_score(p1_cards), _calculate_score(p2_cards))
