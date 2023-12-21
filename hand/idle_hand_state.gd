# Look up class namespace stuff
class_name IdleHandState extends HandState

func _ready():
	state_name = "idle"
	
func animate_hand():
	HandAnimations.idle_animation(get_idle_cards(), hand)

func handle_mouse_entered_card(card: Card):
	hand.change_state("hovered")
	hand.state.set_hovered_card(card)

func handle_mouse_exited_card(_card: Card):
	return
	
func get_idle_cards():
	return hand.get_cards()

func handle_card_clicked(_card: Card):
	return

func handle_clicked_away():
	return
