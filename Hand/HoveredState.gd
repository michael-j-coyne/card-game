class_name HoveredState extends State

func _ready():
	state_name = "hovered"

func animate(cards_to_animate: Array[Node]):
	if not cards_to_animate: return
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	
	Animations.hovered_animation(cards_to_animate, hand, tween)
