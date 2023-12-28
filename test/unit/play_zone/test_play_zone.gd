extends GutTest

const PlayZoneScene = preload("res://play_zone/play_zone.tscn")

var card_1
var card_2
var card_8
var zone

func before_each():
	card_1 = Card.new()
	card_2 = Card.new()
	card_8 = Card.new()
	card_1.setup("1")
	card_2.setup("2")
	card_8.setup("8")
	
	zone = PlayZoneScene.instantiate()

func after_each():
	card_1.free()
	card_2.free()
	card_8.free()
	zone.free()

func test_add_card_get_card():
	zone._add_card_to_model(card_1, Enums.Player.P1)
	
	assert_eq(zone.get_cards(Enums.Player.P1), [card_1])
	assert_eq(zone.get_cards(Enums.Player.P2), [])
	
func test_get_score():
	zone._add_card_to_model(card_1, Enums.Player.P1)
	
	assert_eq(zone.get_score().p1, 1)
	assert_eq(zone.get_score().p2, 0)

func test_grid_score():
	zone._add_card_to_grid(card_2, Enums.Player.P2)
	assert_eq(zone.get_score().p2, 0)

func test_add_card_to_grid_get_grid():
	assert_eq(zone._get_grid(Enums.Player.P1).get_children(), [])
	
	zone._add_card_to_grid(card_1, Enums.Player.P1)
	
	assert_eq(zone._get_grid(Enums.Player.P1).get_children(), [card_1])

func test_remove_card_from_model():
	zone._add_card_to_model(card_1, Enums.Player.P2)
	assert_eq(zone.get_cards(Enums.Player.P2), [card_1])
	
	zone._remove_card_from_model(card_1, Enums.Player.P2)
	assert_eq(zone.get_cards(Enums.Player.P2), [])

func test_remove_card_from_grid():
	zone._add_card_to_grid(card_8, Enums.Player.P1)
	assert_eq(zone._get_grid(Enums.Player.P1).get_children(), [card_8])
	
	zone._remove_card_from_grid(card_8, Enums.Player.P1)
	assert_eq(zone._get_grid(Enums.Player.P1).get_children(), [])
