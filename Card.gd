extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_width() -> int:
	return $Background.texture.get_width() * $Background.scale.x

func get_height() -> int:
	return $Background.texture.get_height() * $Background.scale.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
