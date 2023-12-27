extends Node

var p1_cards: Array[Card] = []
var p2_cards: Array[Card] = []

# 
func _sum_cards(cards: Array[Card]) -> int:
	return cards.reduce(func(acc, card): return acc + card.get_value(), 0)

func get_score() -> Score:
	return Score.new(_sum_cards(p1_cards), _sum_cards(p2_cards))
