class_name GreenWizard
extends Enemy

func _process(_delta) -> void:
	if can_fire_spell and !animations.animation == "windup":
		animations.play("windup")
	elif !can_fire_spell and !animations.animation == "idle" and !animations.animation == "attack" and !animations.animation == "hurt":
		animations.play("idle")

func shoot() -> void:
	#shoot spell
	if player_seen and can_fire_spell:
		var new_spell : BaseSpell = _spell_scene.instantiate()
		var look_rotation = Vector2(cos(line_of_sight.rotation), sin(line_of_sight.rotation))
		
		new_spell.spawn(center.global_position+(spell_spawn_location.position.x*look_rotation), _spell_velocity, _spell_lifetime, _spell_acceleration)
		new_spell.set_direction(look_rotation.normalized())
		get_parent().add_child(new_spell)
		can_fire_spell = false
		start_spell_timers()
		animations.play("attack")
		await animations.animation_finished
		if animations.animation == "attack":
			animations.play("idle")
	return

func _physics_process(_delta) -> void:
	#state_manager.physics_process(_delta)
	if player_ref:
		line_of_sight.look_at(player_ref.global_position)
		line_of_follow.look_at(player_ref.global_position)
		check_player_seen()
		if !player_following:
			player_following = player_seen
		else:
			check_should_follow()
		if player_seen or player_following:
			#print((player_ref.global_position-global_position).length())
			if (player_ref.global_position-global_position).length() > _distance_to_keep:
				set_movement_target(player_ref.global_position)
			else:
				var position_to_move : Vector2 = (global_position - player_ref.global_position).normalized()*_distance_to_keep
				set_movement_target(global_position + position_to_move)
				
			animations.look_at(player_ref.global_position)
		else:
			set_movement_target(global_position)
	shoot()
	
	velocity.x = move_toward(velocity.x, 0, decceleration)
	velocity.y = move_toward(velocity.y, 0, decceleration)
	move_and_slide()

func spell_collision(spell:BaseSpell) -> void:
	animations.play("hurt")
	TextPopper.root_pop_text("[center][color=#A8201A]-"+str(spell.get_damage()), global_position, self, 1.0, 1.0, 50, 10)
	health = health - spell.get_damage()
	if health <= 0:
		leave_body(spell.get_direction().normalized()*spell.get_speed())
		destruct()
	else:
		velocity += spell.get_direction().normalized()*200
	await animations.animation_finished
	if animations.animation == "hurt":
		animations.play("idle")
