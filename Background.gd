class_name Background extends Sprite2D

var dragging = false

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var clicked_in_rect = get_rect().has_point(to_local(event.position))
		
		if event.pressed and clicked_in_rect:
			if not dragging:
				dragging = true
				
		if not event.pressed and dragging:
			dragging = false
