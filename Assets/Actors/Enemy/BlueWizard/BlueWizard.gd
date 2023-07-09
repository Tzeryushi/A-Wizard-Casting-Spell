extends GreenWizard

func _physics_process(_delta) -> void:
	#state_manager.physics_process(_delta)
	if player_ref:
		line_of_sight.look_at(player_ref.global_position)
		line_of_follow.look_at(player_ref.global_position)
		player_seen = is_player_seen()
		if !player_following:
			player_following = player_seen
		else:
			player_following = should_follow()
		if player_seen or player_following:
			if (player_ref.global_position-global_position).length() > _distance_to_keep:
				set_movement_target(player_ref.global_position)
			else:
				var position_to_move : Vector2 = (global_position - player_ref.global_position).normalized()*_distance_to_keep
				set_movement_target(global_position + position_to_move)
				
			animations.look_at(player_ref.global_position)
		else:
			set_movement_target(global_position)
	shoot()
	
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
	move_and_slide()
