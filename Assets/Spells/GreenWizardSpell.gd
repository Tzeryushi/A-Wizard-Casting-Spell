class_name GreenWizardSpell
extends BaseSpell

@export var _body_scene : PackedScene #in case we miss

func _process(_delta) -> void:
	#countdown to lifetime.
	_lifetime -= _delta
	if _lifetime <= 0.0 and !_hit or _speed < 400 and !_hit:
		no_hit_destroy()

func no_hit_destroy() -> void:
	leave_body(_direction*_speed)
	queue_free()

func _physics_process(_delta) -> void:
	_speed = move_toward(_speed, 0, _acceleration)
	global_position += _direction * _speed * _delta
	rotation = _direction.angle()

func destroy() -> void:
	trail.hit = true
	Shake.shake(6.0, 0.2)
	AudioManager.play("res://Art/SFX/swish_4.wav")
	var blast : ParticleAnimation = blast_scene.instantiate()
	get_parent().add_child(blast)
	blast.rotation = rotation
	blast.global_position = global_position
	blast.play()
	queue_free()

func leave_body(impulse:Vector2) -> void:
	var new_body : BaseBody = _body_scene.instantiate()
	new_body.global_position = global_position
	new_body.apply_impulse(impulse)
	get_parent().call_deferred("add_child", new_body)

func _on_hitbox_body_entered(body):
	if body is Enemy and body.is_in_group("Enemy"):
		body.spell_collision(self)
	elif body is Player and body.is_in_group("Player"):
		body.spell_collision(self)
	elif body.is_in_group("Environment"):
		leave_body(-_direction*_speed/3)
	elif body.is_in_group("Body"):
		leave_body(-_direction*_speed/2)
	if !_hit:
		_hit = true
		destroy()

func _on_hitbox_area_entered(area):
	if area.is_in_group("Spell"):
		leave_body(-_direction*_speed/2)
		if !_hit:
			_hit = true
			destroy()
