class_name HoveredHandState extends HandState

var hovered_card

func _ready():
	state_name = "hovered"

func animate_hand():
	HandAnimations.hovered_animation(hovered_card, hand)
	
func handle_mouse_entered_card(card: Card):
	return
	
func handle_mouse_exited_card(_card: Card):
	# I don't like this. It feels hacky. I want a better way of handling when
	# the mouse exits a card, since we may be exiting one card and entering a new one,
	# in that case we shouldn't go idle, we should just change the hovered_card.
	hand.change_state("idle")

func handle_card_clicked(card: Card):
	hand.change_state("selected")
	hand.state.set_selected_card(card)

func handle_clicked_away():
	return

func get_hovered_card() -> Card:
	return hovered_card
	
func set_hovered_card(card: Card):
	if not hovered_card:
		hovered_card = card
		return
		
	if card.get_index() > hovered_card.get_index():
		hovered_card = card

func get_idle_cards():
	return hand.get_cards().filter(func(card): return card != hovered_card)
