class_name HandState extends Node

var tween: Tween
var hand: Hand
var state_name: String

func setup(hand: Hand):
	self.hand = hand

func animate(_cards_to_animate: Array[Node]):
	pass
