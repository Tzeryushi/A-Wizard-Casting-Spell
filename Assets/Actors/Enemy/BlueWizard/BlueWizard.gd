extends Enemy

func run_sight_follow_logic() -> void:
	if player_ref:
		line_of_sight.look_at(player_ref.global_position)
		line_of_follow.look_at(player_ref.global_position)
		
		check_player_seen()
		
		if !player_following:
				player_following = player_seen
		else:
			check_should_follow()
		if player_seen or player_following:
			if ((player_ref.global_position-global_position).length() < _distance_to_keep+150) and ((player_ref.global_position-global_position).length() > _distance_to_keep-100) and is_shot_obstructed():
				#create a vector sized from player to enemy, check if free of collisions; if not, rotate slightly and check again
				var base_vector : Vector2 = global_position - player_ref.global_position
				var rotate_base : float = deg_to_rad(1)
				var rotate_amount : float = deg_to_rad(5)
				var space_found : bool = false
				var space_state = get_world_2d().direct_space_state
				var ray_query = PhysicsRayQueryParameters2D.create(player_ref.global_position, player_ref.global_position+base_vector, 0x0001)
				var counter : int = 0
				while !space_found:
					var result = space_state.intersect_ray(ray_query)
					if !result.is_empty():
						rotate_amount = (-1*rotate_amount) + (-1*sign(rotate_amount)*rotate_base)
						ray_query.to = player_ref.global_position+base_vector.rotated(rotate_amount)
						if rotate_amount > PI:
							set_movement_target(player_ref.global_position)
					else:
						space_found = true
						set_movement_target(player_ref.global_position+base_vector.rotated(rotate_amount*1.2))
					if !space_found:
						counter += 1
						if counter >= 180:
							space_found = true
							set_movement_target(player_ref.global_position)
			elif (player_ref.global_position-global_position).length() > _distance_to_keep:
				set_movement_target(player_ref.global_position)
			else:
				
				var position_to_move : Vector2 = (global_position - player_ref.global_position).normalized()*_distance_to_keep
				set_movement_target(global_position + position_to_move)
				
			animations.look_at(player_ref.global_position)
		else:
			#outside of follow, just stay stationary
			set_movement_target(global_position)
