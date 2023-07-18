class_name GreenWizard
extends Enemy

func _process(_delta) -> void:
	if can_fire_spell and !animations.animation == "windup":
		animations.play("windup")
	elif !can_fire_spell and !animations.animation == "idle" and !animations.animation == "attack" and !animations.animation == "hurt":
		print("huh")
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

func set_movement_values() -> void:
	velocity.x = move_toward(velocity.x, 0, decceleration)
	velocity.y = move_toward(velocity.y, 0, decceleration)

func spell_collision(spell:BaseSpell) -> void:
	animations.play("hurt")
	TextPopper.root_pop_text("[center][color=#A8201A]-"+str(spell.get_damage()), global_position, self, 1.0, 1.0, 50, 10)
	health = health - spell.get_damage()
	if health <= 0:
		if !has_been_killed:
			has_been_killed = true
			leave_body(spell.get_direction().normalized()*spell.get_speed())
			destruct()
		else:
			TextPopper.root_jolt_text("[center][rainbow]OVERKILL!!", 50.0, global_position, 1.0, 2.0, 45, 10)
	else:
		velocity += spell.get_direction().normalized()*200
	await animations.animation_finished
	if animations.animation == "hurt":
		animations.play("idle")
