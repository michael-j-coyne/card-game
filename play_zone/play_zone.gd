class_name PlayZone extends VBoxContainer

signal p1_zone_clicked(zone: PlayZone)
signal p2_zone_clicked(zone: PlayZone)

func get_grid(player: String) -> GridContainer:
	if player == "P1":
		return get_node("P1MarginContainer/Player1Grid")
	elif player == "P2":
		return get_node("P2MarginContainer/Player2Grid")
	else:
		push_error("Player must be either string 'P1' for player one or 'P2' for player two")
		assert(false)
		return

func scale_card(card: Card):
	card["custom_minimum_size"] = Vector2(50, 75)

func add_card(card: Card, player: String):
	var target_grid := get_grid(player)
	scale_card(card)
	target_grid.add_child(card)
	
func get_score(player: String):
	var cards = get_grid(player).get_children()
	return cards.reduce(func(acc, card): return acc + card.get_value(), 0)

func _on_p1_zone_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		p1_zone_clicked.emit(self)

func _on_p2_zone_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		p2_zone_clicked.emit(self)
