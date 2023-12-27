class_name SelectedHandState extends HandState

var selected_card

func _ready():
	state_name = "selected"

func animate_hand():
	if not selected_card:
		push_error("You are tying to call the selected animation but no card has been selected")

	HandAnimations.hovered_animation(selected_card, hand)

func get_idle_cards():
	return hand.get_cards().filter(func(card): return card != selected_card)

func set_selected_card(card: Card):
	selected_card = card

func handle_mouse_entered_card(_card: Card):
	return

func handle_mouse_exited_card(_card: Card):
	return

func handle_card_clicked(card: Card):
	set_selected_card(card)

func handle_clicked_away():
	hand.change_state("idle")
