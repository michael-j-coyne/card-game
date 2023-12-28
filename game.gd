extends Node

const CardScene = preload('res://Card.tscn')

var rng = RandomNumberGenerator.new()

func _zone_clicked(zone: PlayZone, player: Enums.Player):
	var hand = get_node("Hand") if player == Enums.Player.P1 else get_node("Hand2")
	
	if hand.has_active_card():
		var card : Card = hand.get_active_card()
		var new_card := CardScene.instantiate()
		new_card.setup(card.get_card_name())
		hand.remove_card(card)
		zone.add_card(new_card, player)
		
# temp, testing code
func generate_random_card() -> Card:
	var card_name := str(rng.randi_range(1,10))
	var card := CardScene.instantiate()
	card.setup(card_name)
	return card

# temp, testing code
func _input(event):
	var hand = get_node("Hand")
	var hand2 = get_node("Hand2")
	if event.is_action_pressed("ui_accept"):
		var card_to_add = generate_random_card()
		var second_card = generate_random_card()
		hand.add_card(card_to_add)
		hand2.add_card(second_card)
		

func _p1_zone_clicked(zone: PlayZone):
	_zone_clicked(zone, Enums.Player.P1)

func _p2_zone_clicked(zone: PlayZone):
	_zone_clicked(zone, Enums.Player.P2)
	
