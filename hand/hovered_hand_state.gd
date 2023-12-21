class_name HoveredHandState extends HandState

var hovered_card

func _ready():
	state_name = "hovered"

func animate(cards_to_animate: Array[Node]):
	if not cards_to_animate: return
	HandAnimations.hovered_animation(cards_to_animate, hand)
	
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
