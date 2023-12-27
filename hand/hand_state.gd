class_name HandState extends Node

var hand: Hand
var state_name: String

func setup(hand_ref: Hand):
	self.hand = hand_ref

func animate_hand():
	pass
	
func get_idle_cards():
	pass
	
func handle_mouse_entered_card(_card: Card):
	pass

func handle_mouse_exited_card(_card: Card):
	pass

func handle_card_clicked(_card: Card):
	pass

func handle_clicked_away():
	pass
