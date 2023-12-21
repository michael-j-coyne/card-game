class_name HandAnimations extends Node

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

static func idle_animation(idle_cards: Array[Node], hand):
	const idle_duration = CARD_IDLE_ANIMATION_DURATION_SECONDS
	const hovered_duration = CARD_HOVERED_ANIMATION_DURATION_SECONDS
	
	var hand_size = hand.get_card_count()
	
	for card in idle_cards:
		var tween = card.create_tween()
		tween.set_parallel(true)
		
		var hand_ratio = HandFuncs.hand_ratio(card.get_index(), hand_size)
		var pos = HandFuncs.relative_card_default_pos(
			card.get_index(), hand_size, card.get_base_width())
			
		# let make a function for getting the rotation amount so we can unit test it
		var rotation_amt := rotation_curve.sample(hand_ratio) * BASE_ROTATION_DEGREES
		
		tween.tween_property(card, "position", pos, idle_duration)
		tween.tween_property(card, "rotation_degrees", rotation_amt, idle_duration)
		
		tween.tween_property(card, "scale", Vector2(1, 1), hovered_duration)
		card.z_index = DEFAULT_CARD_Z_INDEX

static func hovered_animation(hovered_card: Card, hand: Hand):
		const hovered_duration = CARD_HOVERED_ANIMATION_DURATION_SECONDS
		
		if not hovered_card:
			printerr("You are trying to do the hovered animation when there is no hovered card")
	
		var tween = hovered_card.create_tween()
		tween.set_parallel(true)
		
		# this calculation is convoluted and state dependent, lets make it functional.
		var base_screen_size = hand.get_viewport().content_scale_size
		var y_pos = base_screen_size.y - (hovered_card.get_height())
		var card_default_pos = HandFuncs.relative_card_default_pos(
			hovered_card.get_index(), hand.get_card_count(), hovered_card.get_base_width())
		var hovered_pos = hand.to_local(Vector2(hand.to_global(card_default_pos).x, y_pos))
		hovered_pos.y += hovered_card.get_origin_offset().y
		
		tween.tween_property(hovered_card, "scale", CARD_EXPANSION_FACTOR, hovered_duration)
		tween.tween_property(hovered_card, "rotation_degrees", 0, hovered_duration)
		tween.tween_property(hovered_card, "position", hovered_pos, hovered_duration)
		hovered_card.z_index = HOVERED_CARD_Z_INDEX
		
		# TODO: I think I should just pass the idle cards as an argument, and I should delete
		# the get_idle_cards func in hand.gd
		idle_animation(hand.get_idle_cards(), hand)
