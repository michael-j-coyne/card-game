class_name Card extends Node2D

signal mouse_entered(card: Card)
signal mouse_exited(card: Card)
signal card_selected(card: Card)

var _value = 0

func get_width() -> int:
	var bg = get_node("Area2D/Background")
	return bg.texture.get_width() * bg.scale.x

func get_height() -> int:
	var bg = get_node("Area2D/Background")
	return bg.texture.get_height() * bg.scale.y

func init(card_name: String):
	var path = str("res://assets/cards/", card_name ,".png")
	set_texture(path)
	
	# hack!
	_value = int(card_name)
	
func get_value() -> int:
	return _value
	
func set_texture(path):
	var bg = get_node("Area2D/Background")
	bg.texture = load(path)

func _on_area_2d_mouse_entered():
	mouse_entered.emit(self)
	
func _on_area_2d_mouse_exited():
	mouse_exited.emit(self)

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		card_selected.emit(self)
