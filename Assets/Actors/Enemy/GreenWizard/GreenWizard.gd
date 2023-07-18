class_name GreenWizard
extends Enemy


func set_movement_values() -> void:
	velocity.x = move_toward(velocity.x, 0, decceleration)
	velocity.y = move_toward(velocity.y, 0, decceleration)
