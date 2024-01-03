class_name Game extends Node

const CardScene = preload('res://card.tscn')
const HandScene = preload('res://hand/hand.tscn')
const PlayZoneScene = preload('res://play_zone/play_zone.tscn')

const NUM_ZONES = 3
const SCREEN_SIZE = Vector2i(1920, 1080)

var rng = RandomNumberGenerator.new()
var p1_hand: Hand
# TEMP
var p2_hand: Hand
var _play_zones: Array[PlayZone]
@onready var zone_grid: GridContainer = get_node("ZoneMarginContainer/ZoneGrid")

static func _compute_winner(s: Score) -> Enums.Winner:
	if s.p1 > s.p2:
		return Enums.Winner.P1
	elif s.p1 < s.p2:
		return Enums.Winner.P2
	return Enums.Winner.TIE
	
static func _compute_zone_scores(zones: Array[PlayZone]) -> Array[Score]:
	var result: Array[Score] = []
	result.assign(zones.map(func(z): return z.get_score()))
	return result

static func _compute_num_wins(zone_scores: Array[Score]) -> Score:
	var zone_winners = zone_scores.map(func(s): return Game._compute_winner(s))
	var p1_wins = zone_winners.count(Enums.Winner.P1)
	var p2_wins = zone_winners.count(Enums.Winner.P2)
	return Score.new(p1_wins, p2_wins)

func _ready():
	new_game()

func _enter_tree():
	get_tree().root.content_scale_size = SCREEN_SIZE

func delete_zone_from_view(zone: PlayZone):
	zone_grid.remove_child(zone)
	zone.queue_free()
	
func clear_zone_model():
	_play_zones = []
	
func cleanup():
	for zone in _get_zones():
		delete_zone_from_view(zone)
	
	clear_zone_model()
	
	remove_child(p1_hand)
	p1_hand.queue_free()
	
	# TEMP
	remove_child(p2_hand)
	p2_hand.queue_free()

func new_game():
	p1_hand = HandScene.instantiate()
	add_child(p1_hand)
	
	# TEMP
	p2_hand = HandScene.instantiate()
	p2_hand.global_position = Vector2(960, 500)
	add_child(p2_hand)
	
	for i in NUM_ZONES:
		var zone = PlayZoneScene.instantiate()
		zone.p1_zone_clicked.connect(_p1_zone_clicked)
		zone.p2_zone_clicked.connect(_p2_zone_clicked)
		_add_zone(zone)
	

func _zone_clicked(zone: PlayZone, player: Enums.Player):
	# TEMP
	var hand = p1_hand if player == Enums.Player.P1 else p2_hand
	
	if hand.has_active_card():
		var card : Card = hand.get_active_card()
		var new_card := CardScene.instantiate()
		new_card.setup(card.get_card_name())
		hand.remove_card(card)
		zone.add_card(new_card, player)
		
# temp, testing code
func _generate_random_card() -> Card:
	var card_name := str(rng.randi_range(1,10))
	var card := CardScene.instantiate()
	card.setup(card_name)
	return card
	
func _get_zones() -> Array[PlayZone]:
	return _play_zones
	
func _add_zone(zone: PlayZone) -> void:
	_get_zones().append(zone)
	zone_grid.add_child(zone)

func _get_zone_scores() -> Array[Score]:
	return Game._compute_zone_scores(_get_zones())

func _get_winner() -> Enums.Winner:
	var zone_wins = Game._compute_num_wins(_get_zone_scores())
	return Game._compute_winner(zone_wins)

# temp, testing code
func _input(event):
	if event.is_action_pressed("ui_accept"):
		var card_to_add = _generate_random_card()
		var second_card = _generate_random_card()
		p1_hand.add_card(card_to_add)
		# TEMP
		p2_hand.add_card(second_card)
	elif event.is_action_pressed("ui_text_backspace"):
		# testing code only
		cleanup()
		new_game()

func _p1_zone_clicked(zone: PlayZone):
	_zone_clicked(zone, Enums.Player.P1)

func _p2_zone_clicked(zone: PlayZone):
	_zone_clicked(zone, Enums.Player.P2)

func _on_game_backdrop_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if p1_hand: p1_hand.change_state("idle")
		# TEMP, REMOVE P2 HAND LOGIC
		if p2_hand: p2_hand.change_state("idle")
			
		
func _on_calculate_winner_button_pressed():
	var winner = _get_winner()
	
	if winner == Enums.Winner.P1:
		print("P1 won!")
	elif winner == Enums.Winner.P2:
		print("P2 won!")
	else:
		print("Tie!")
		
	get_node("CalculateWinnerButton").release_focus()
