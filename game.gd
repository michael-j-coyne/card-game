class_name Game extends Node

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
	
func _get_zones() -> Array[PlayZone]:
	return [get_node("PlayZone"), get_node("PlayZone2"), get_node("PlayZone3")]

static func _winner(s: Score) -> Enums.Winner:
	if s.p1 > s.p2:
		return Enums.Winner.P1
	elif s.p1 < s.p2:
		return Enums.Winner.P2
	return Enums.Winner.TIE
	
static func _compute_zone_scores(zones: Array[PlayZone]) -> Array[Score]:
	var result: Array[Score] = []
	result.assign(zones.map(func(z): return z.get_score()))
	return result

func _get_zone_scores() -> Array[Score]:
	return Game._compute_zone_scores(_get_zones())

static func _num_wins(zone_scores: Array[Score]) -> Score:
	var zone_winners = zone_scores.map(func(s): return Game._winner(s))
	var p1_wins = zone_winners.reduce(
		func(acc, w): return acc + 1 if w == Enums.Winner.P1 else acc, 0)
	var p2_wins = zone_winners.reduce(
		func(acc, w): return acc +1 if w == Enums.Winner.P2 else acc, 0)
	return Score.new(p1_wins, p2_wins)

func compute_winner() -> Enums.Winner:
	var zone_wins = Game._num_wins(_get_zone_scores())
	return Game._winner(zone_wins)

func _on_calculate_winner_button_pressed():
	var winner = compute_winner()
	
	if winner == Enums.Winner.P1:
		print("P1 won!")
	elif winner == Enums.Winner.P2:
		print("P2 won!")
	else:
		print("Tie!")
		
	get_node("CalculateWinnerButton").release_focus()

func _on_game_backdrop_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_node("Hand").change_state("idle")
		get_node("Hand2").change_state("idle")
