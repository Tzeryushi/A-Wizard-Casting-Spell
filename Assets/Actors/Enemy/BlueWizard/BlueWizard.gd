extends Enemy

func set_movement_values() -> void:
	if !navigation_agent.is_navigation_finished():
		var current_agent_position:Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()
		
		var new_velocity : Vector2 = next_path_position - current_agent_position
		new_velocity = new_velocity.normalized()
		velocity.x = move_toward(velocity.x, max_movement_speed*new_velocity.x, acceleration)
		velocity.y = move_toward(velocity.y, max_movement_speed*new_velocity.y, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, decceleration)
		velocity.y = move_toward(velocity.y, 0, decceleration)
