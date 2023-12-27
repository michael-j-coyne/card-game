extends GutTest

func test_score():
	var score = Score.new()
	assert_eq(score.p1, 0)
	assert_eq(score.p2, 0)
	
	score = Score.new(2, 10)
	assert_eq(score.p1, 2)
	assert_eq(score.p2, 10)
