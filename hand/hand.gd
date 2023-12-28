class_name Hand extends Node2D

const CardScene = preload('res://Card.tscn')
const CARD_SPAWN_POS = Vector2(1000, 0)

var state: HandState
var state_factory

func _ready():
	state_factory = HandStateFactory.new()
	change_state("idle")

func animate_hand():
	state.animate_hand()

func change_state(new_state_name):
	if state != null:
		state.queue_free()
	state = state_factory.get_state(new_state_name).new()
	state.setup(self)
	add_child(state)

func get_cards() -> Array[Node]:
	return get_node("Cards").get_children()

func get_card_count() -> int:
	return get_node("Cards").get_child_count()

func get_idle_cards():
	return state.get_idle_cards()

func has_active_card() -> bool:
	return state.state_name == "selected"

# Careful returning null
func get_active_card() -> Card:
	if state.state_name == "selected":
		return state.selected_card
		
	return null

func _process(_delta : float) -> void:
	animate_hand()

func _on_mouse_entered_card(card: Card):
	state.handle_mouse_entered_card(card)

func _on_mouse_exited_card(card: Card):
	state.handle_mouse_exited_card(card)
	
func _on_card_clicked(card: Card):
	state.handle_card_clicked(card)

func add_card (card: Card):
	get_node('Cards').add_child(card)
	card.position = CARD_SPAWN_POS
	card.mouse_entered_card.connect(_on_mouse_entered_card)
	card.mouse_exited_card.connect(_on_mouse_exited_card)
	card.card_clicked.connect(_on_card_clicked)
	
func remove_card(card: Card):
	# This is a workaround. I don't think we *always* want to go to the idle state
	# when a card is removed. But this works well enough for now.
	change_state("idle")
	
	card.queue_free()
