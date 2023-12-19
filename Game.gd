extends Node

const CardScene = preload('res://Card.tscn')

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _p1_zone_clicked(zone: PlayZone):
	var hand = get_node("Hand")
	var card : Card = hand.get_selected_card()
	if card:
		var new_card := CardScene.instantiate()
		new_card.init(card.get_card_name())
		hand.remove_card(card)
		zone.add_card(new_card, "P1")
