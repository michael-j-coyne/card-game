extends Node

const CardScene = preload('res://Card.tscn')

var rng = RandomNumberGenerator.new()

func _zone_clicked(zone: PlayZone, player: String):
	var hand = get_node("Hand")
	var card : Card = hand.get_selected_card()
	if card:
		var new_card := CardScene.instantiate()
		# use setup here instead of init
		new_card.init(card.get_card_name())
		hand.remove_card(card)
		zone.add_card(new_card, player)

# temp, testing code
func generate_random_card() -> Card:
	var card_name := str(rng.randi_range(1,10))
	var card := CardScene.instantiate()
	card.init(card_name)
	return card

# temp, testing code
func _input(event):
	var hand = get_node("Hand")
	if event.is_action_pressed("ui_accept"):
		var card_to_add = generate_random_card()
		hand.add_card(card_to_add)

func _p1_zone_clicked(zone: PlayZone):
	_zone_clicked(zone, "P1")

func _p2_zone_clicked(zone: PlayZone):
	_zone_clicked(zone, "P2")
	
