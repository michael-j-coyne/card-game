class_name HandState extends Node

var hand: Hand
var state_name: String

func setup(hand: Hand):
	self.hand = hand

func animate_hand():
	pass
	
func get_idle_cards():
	pass
	
func handle_mouse_entered_card(_card: Card):
	pass

func handle_mouse_exited_card(_card: Card):
	pass
