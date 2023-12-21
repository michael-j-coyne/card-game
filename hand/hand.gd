class_name Hand extends Node2D

const CardScene = preload('res://Card.tscn')

const CARD_SPAWN_POS = Vector2(1000, 0)

var selected_card = null
var state: HandState
var state_factory

func _ready():
	state_factory = HandStateFactory.new()
	change_state("idle")

func animate(cards_to_animate: Array[Node]):
	state.animate(cards_to_animate)

func change_state(new_state_name):
	if state != null:
		state.queue_free()
	state = state_factory.get_state(new_state_name).new()
	state.setup(self)
	add_child(state)

func get_selected_card() -> Card:
	return selected_card

func _card_default_pos(card: Card) -> Vector2:
	var num_cards_in_hand = get_node("Cards").get_child_count()
	var hand_width = HandFuncs.hand_width(num_cards_in_hand, card.get_base_width())
	var hand_ratio = HandFuncs.hand_ratio(card.get_index(), num_cards_in_hand)
	
	return HandFuncs.default_pos(hand_ratio, hand_width)

func get_cards() -> Array[Node]:
	return get_node("Cards").get_children()

func get_idle_cards():
	return state.get_idle_cards()

func _process(_delta : float) -> void:
	animate(get_cards())

func _on_mouse_entered_card(card: Card):
	state.handle_mouse_entered_card(card)

func _on_mouse_exited_card(card: Card):
	state.handle_mouse_exited_card(card)
	
func _on_card_selected(card: Card):
	selected_card = card

func add_card (card: Card):
	get_node('Cards').add_child(card)
	card.position = CARD_SPAWN_POS
	card.mouse_entered_card.connect(_on_mouse_entered_card)
	card.mouse_exited_card.connect(_on_mouse_exited_card)
	card.card_selected.connect(_on_card_selected)
	
func remove_card(card: Card):
	if card == selected_card:
		selected_card = null
	card.queue_free()

# I'm not sure if this solution will work as I add more stuff.
func _on_game_backdrop_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		selected_card = null
