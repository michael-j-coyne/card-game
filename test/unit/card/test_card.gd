extends GutTest

var card
const base_width = 100.0
const base_height = 100.0
const scale = Vector2(2.0, 2.0)

func before_each():
	card = Card.new()
	card.size = Vector2(base_width, base_height)
	card.scale = scale

func test_get_width():
	assert_eq(card.get_width(), 200.0)

func test_get_height():
	assert_eq(card.get_height(), 200.0)
	
func test_get_base_height():
	assert_eq(card.get_base_height(), 100.0)
