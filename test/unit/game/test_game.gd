extends GutTest

var test_lib = Game

func test_compute_winner_zeros():
	var score = Score.new()
	assert_eq(test_lib._compute_winner(score), Enums.Winner.TIE)

func test_compute_winner_p1_win():
	var score = Score.new(7, -1)
	assert_eq(test_lib._compute_winner(score), Enums.Winner.P1)

func test_compute_winner_tie():
	var score = Score.new(4, 4)
	assert_eq(test_lib._compute_winner(score), Enums.Winner.TIE)
	
func test_compute_winner_p2_win():
	var score = Score.new(8, 20)
	assert_eq(test_lib._compute_winner(score), Enums.Winner.P2)
