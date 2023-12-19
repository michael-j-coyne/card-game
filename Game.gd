extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _p1_zone_clicked(zone: PlayZone):
	var hand = get_node("Hand")
	var card = hand.get_selected_card()
	if card:
		hand.remove_card(card)
		zone.add_card(card, "P1")
