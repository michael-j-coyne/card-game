class_name Card extends Node2D

signal mouse_entered(card: Card)
signal mouse_exited(card: Card)

func get_width() -> int:
	var bg = get_node("Area2D/Background")
	return bg.texture.get_width() * bg.scale.x

func get_height() -> int:
	var bg = get_node("Area2D/Background")
	return bg.texture.get_height() * bg.scale.y

func _on_area_2d_mouse_entered():
	mouse_entered.emit(self)
	
func _on_area_2d_mouse_exited():
	mouse_exited.emit(self)
