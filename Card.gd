class_name Card extends Node2D

func get_width() -> int:
	var bg = get_node("Area2D/Background")
	return bg.texture.get_width() * bg.scale.x

func get_height() -> int:
	var bg = get_node("Area2D/Background")
	return bg.texture.get_height() * bg.scale.y
