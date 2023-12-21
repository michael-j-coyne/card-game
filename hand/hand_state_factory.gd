class_name HandStateFactory

var states

func _init():
	states = {
		"idle": IdleHandState,
		"hovered": HoveredHandState,
		"selected": SelectedHandState
	}

func get_state(state_name):
	if states.has(state_name):
		return states.get(state_name)
	else:
		printerr("No state ", state_name, " in state factory!")
