extends Enemy

func play_animation_move() -> void:
	current_animation = ANIMATION_TYPE.MOVE
	animations.play("moving")
	return
func play_animation_windup_move() -> void:
	current_animation = ANIMATION_TYPE.WINDUP_MOVE
	animations.play("moving_windup")
	return
