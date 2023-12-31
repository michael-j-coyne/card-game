extends GutTest

var hand_ratio_params = ParameterFactory.named_parameters(
	["card_index", "hand_size", "expected"],
	[

		# hand size >= 2
		[1, 3, 0.5],
		[2, 6, 0.4],
		# hand_size < 2
		[0, 1, 0.5],
		[1, 4, 1.0 / 3.0],

		# boundary: card_index = hand size - 1
		[4, 5, 1.0],
		# boundary: hand size = 2
		[1, 2, 1.0],
		
		# invalid input: card_index > hand_size - 1
		[1, 1, 0.5],
		# invalid input: card_index < 0
		[-1, 5, 0.5],
		# invalid input: hand_size < 0
		[0, -1, 0.5]
		
])

func test_hand_ratio(params = use_parameters(hand_ratio_params)):
	var result = HandFuncs.hand_ratio(params.card_index, params.hand_size)
	assert_eq(result, params.expected)

func test_hand_width():
	var result = HandFuncs.hand_width(5, 100, 30)
	assert_eq(result, 380.0)
