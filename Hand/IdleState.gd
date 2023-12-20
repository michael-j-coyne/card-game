# Look up class namespace stuff
class_name IdleState extends State

func _ready():
	state_name = "idle"

func animate(cards_to_animate: Array[Node]):
	if not cards_to_animate: return
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	
	Animations.idle_animation(cards_to_animate, hand, tween)
