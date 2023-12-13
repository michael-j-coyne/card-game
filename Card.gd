extends Node2D

func get_width() -> int:
	return $Background.texture.get_width() * $Background.scale.x

func get_height() -> int:
	return $Background.texture.get_height() * $Background.scale.y

