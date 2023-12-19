class_name Card extends TextureRect

signal card_selected(card: Card)
signal mouse_entered_card(card: Card)
signal mouse_exited_card(card: Card)

var _value = 0
var _card_name = ""

func _ready():
	pivot_offset = size / 2

func get_width() -> float:
	return size.x

func get_height() -> float:
	return size.y

func get_value() -> int:
	return _value
	
func get_card_name() -> String:
	return _card_name

func init(card_name: String):
	var path = str("res://assets/cards/", card_name ,".png")
	self.texture = load(path)
	
	# hack!
	_value = int(card_name)
	_card_name = card_name

func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		card_selected.emit(self)

func _on_mouse_exited():
	mouse_exited_card.emit(self)

func _on_mouse_entered():
	mouse_entered_card.emit(self)
