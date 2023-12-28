class_name PlayZone extends VBoxContainer

var _p1_cards: Array[Card] = []
var _p2_cards: Array[Card] = []

var _cards: Dictionary = {
	Enums.Player.P1: _p1_cards,
	Enums.Player.P2: _p2_cards
}

signal p1_zone_clicked(zone: PlayZone)
signal p2_zone_clicked(zone: PlayZone)

static func _sum_cards(cards: Array[Card]) -> int:
	return cards.reduce(func(acc, card): return acc + card.get_value(), 0)

func _get_grid(player: Enums.Player) -> GridContainer:
	if player == Enums.Player.P1:
		return get_node("P1Parent/P1MarginContainer/Player1Grid")
	return get_node("P2Parent/P2MarginContainer/Player2Grid")
	
func _set_card_default_size(card: Card):
	# TODO: const for this value
	card["custom_minimum_size"] = Vector2(50, 75)

func _add_card_to_grid(card: Card, player: Enums.Player):
	var target_grid := _get_grid(player)
	_set_card_default_size(card)
	target_grid.add_child(card)

func _add_card_to_model(card: Card, player: Enums.Player) -> void:
	assert(player in _cards)
	assert(_cards[player] is Array[Card])
	_cards[player].append(card)

func add_card(card: Card, player: Enums.Player) -> void:
	_add_card_to_model(card, player)
	_add_card_to_grid(card, player)

func get_cards(player: Enums.Player) -> Array[Card]:
	assert(player in _cards)
	# TODO: duplicate the cards themselves to prevent someone from modifying
	# their values
	return _cards[player].duplicate()

func get_score() -> Score:
	return Score.new(
		PlayZone._sum_cards(get_cards(Enums.Player.P1)),
		PlayZone._sum_cards(get_cards(Enums.Player.P2)))

func _on_p1_zone_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		p1_zone_clicked.emit(self)

func _on_p2_zone_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		p2_zone_clicked.emit(self)
