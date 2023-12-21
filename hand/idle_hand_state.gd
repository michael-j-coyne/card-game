# Look up class namespace stuff
class_name IdleHandState extends HandState

func _ready():
	state_name = "idle"
	
func animate(cards_to_animate: Array[Node]):
	if not cards_to_animate: return
	
	HandAnimations.idle_animation(cards_to_animate, hand)

func handle_mouse_entered_card(card: Card):
	hand.change_state("hovered")
	hand.state.handle_mouse_entered_card(card)

func handle_mouse_exited_card(_card: Card):
	return
	
func get_idle_cards():
	return hand.get_cards()
