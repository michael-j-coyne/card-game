class_name Card extends TextureRect

signal card_selected(card: Card)
signal mouse_entered_card(card: Card)
signal mouse_exited_card(card: Card)

var _value = 0
var _card_name = ""

func _ready():
	pivot_offset = size / 2

func get_width() -> float:
	return size.x * scale.x

func get_height() -> float:
	return size.y * scale.y

func get_base_width() -> float:
	return size.x

func get_base_height() -> float:
	return size.y

func get_value() -> int:
	return _value
	
func get_card_name() -> String:
	return _card_name

func setup(card_name: String):
	var path = str("res://assets/cards/", card_name ,".png")
	self.texture = load(path)
	
	# hack!
	_value = int(card_name)
	_card_name = card_name

# Because the node's pivot_offset is in the center, the node's "origin" (topleft) will be
# offset from the "visual origin" / visual topleft. This function returns a vector indicating
# the offset in the x and y direction.
func get_origin_offset():
	# The positioning origin is the 'actual' topleft of the node, which will look different
	# From the visual topleft of the node if the scale is not (1, 1)
	var positioning_origin = Vector2(0, 0)
	var node_center = pivot_offset
	var center_to_positioning_origin = positioning_origin - node_center
	var center_to_visual_topleft = Vector2((size.x * scale.x) / 2.0, (size.y * scale.y) / 2.0) * -1
	var offset = center_to_positioning_origin - center_to_visual_topleft
	return offset

func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		card_selected.emit(self)

func _on_mouse_exited():
	mouse_exited_card.emit(self)

func _on_mouse_entered():
	mouse_entered_card.emit(self)
