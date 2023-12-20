class_name Animations extends Node

const horizontal_spread_curve :=  \
	preload("res://UI/resources/horizontal_card_spread_curve.tres")
const vertical_spread_curve := \
	preload("res://UI/resources/vertical_card_spread_curve.tres")
const rotation_curve := \
	preload("res://UI/resources/hand_rotation_curve.tres")

const BASE_ROTATION_DEGREES = 6.5
const CARD_IDLE_ANIMATION_DURATION_SECONDS = 0.25
const CARD_HOVERED_ANIMATION_DURATION_SECONDS = 0.1
const CARD_SPAWN_POS = Vector2(1000, 0)
const CARD_EXPANSION_FACTOR = Vector2(1.5, 1.5)
const DEFAULT_CARD_Z_INDEX = 0
const HOVERED_CARD_Z_INDEX = 1

static func idle_animation(cards_to_animate: Array[Node], hand: Hand, tween: Tween):
	const idle_duration = CARD_IDLE_ANIMATION_DURATION_SECONDS
	const hovered_duration = CARD_HOVERED_ANIMATION_DURATION_SECONDS
	
	for card in cards_to_animate:
		var hand_ratio = hand._compute_hand_ratio(card.get_index(), cards_to_animate.size())
		var pos := hand._card_default_pos(card)
		var rotation_amt := rotation_curve.sample(hand_ratio) * BASE_ROTATION_DEGREES
		tween.tween_property(card, "position", pos, idle_duration)
		tween.tween_property(card, "rotation_degrees", rotation_amt, idle_duration)
		
		tween.tween_property(card, "scale", Vector2(1, 1), hovered_duration)
		card.z_index = DEFAULT_CARD_Z_INDEX
		
static func hovered_animation(cards_to_animate: Array[Node], hand: Hand, tween: Tween):
		const hovered_duration = CARD_HOVERED_ANIMATION_DURATION_SECONDS
		
		# keep in mind this is not guaranteed to return a value
		var hovered_card = hand.get_hovered_card()
		
		if not hovered_card:
			printerr("You are trying to do the hovered animation when there is no hovered card")
	
		var base_screen_size = hand.get_viewport().content_scale_size
		var y_pos = base_screen_size.y - (hovered_card.get_height())
		var hovered_pos = hand.to_local(Vector2(hand.to_global(hand._card_default_pos(hovered_card)).x, y_pos))
		hovered_pos.y += hovered_card.get_origin_offset().y
		
		tween.tween_property(hovered_card, "scale", CARD_EXPANSION_FACTOR, hovered_duration)
		tween.tween_property(hovered_card, "rotation_degrees", 0, hovered_duration)
		tween.tween_property(hovered_card, "position", hovered_pos, hovered_duration)
		hovered_card.z_index = HOVERED_CARD_Z_INDEX
		
		idle_animation(hand.get_idle_cards(), hand, tween)
