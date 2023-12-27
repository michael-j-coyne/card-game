extends GutTest

func test_add_card():
	var card = Card.new()
	var zone = PlayZone.new()
	card.setup("1")
	
	zone.add_card(card, Enums.Player.P1)
	
	assert_eq(zone.get_score().p1, 1)
	assert_eq(zone.get_score().p2, 0)
	
	card.free()
	zone.free()
	
func test_get_cards():
	var card_2 = Card.new()
	var card_8 = Card.new()
	var zone = PlayZone.new()
	card_2.setup("2")
	card_8.setup("8")

	zone.add_card(card_2, Enums.Player.P2)
	zone.add_card(card_8, Enums.Player.P2)
	
	assert_eq(zone.get_cards(Enums.Player.P2), [card_2, card_8])
	assert_eq(zone.get_cards(Enums.Player.P1), [])
	
	card_2.free()
	card_8.free()
	zone.free()
