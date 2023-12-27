class_name PlayZoneView extends VBoxContainer

signal p1_zone_clicked(zone: PlayZoneView)
signal p2_zone_clicked(zone: PlayZoneView)

func get_grid(player: Enums.Player) -> GridContainer:
	if player == Enums.Player.P1:
		return get_node("P1Parent/P1MarginContainer/Player1Grid")
	return get_node("P2Parent/P2MarginContainer/Player2Grid")
	
func scale_card(card: Card):
	card["custom_minimum_size"] = Vector2(50, 75)

func add_card(card: Card, player: Enums.Player):
	var target_grid := get_grid(player)
	scale_card(card)
	target_grid.add_child(card)
	
func _on_p1_zone_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		p1_zone_clicked.emit(self)

func _on_p2_zone_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		p2_zone_clicked.emit(self)
