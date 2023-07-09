class_name BaseSpell
extends Node2D

@export var blast_scene : PackedScene

@onready var trail := $Trail
@onready var sprite := $Sprite
@onready var hitbox := $Hitbox

var _speed : float = 0.0
var _direction : Vector2 = Vector2.ZERO
var _lifetime : float = 0.0
var _acceleration : float = 0.0
var _damage : int = 1
var _hit : bool = 0.0

func _process(_delta) -> void:
	#countdown to lifetime.
	_lifetime -= _delta
	if _lifetime <= 0.0 and !_hit:
		no_hit_destroy()

func _physics_process(_delta) -> void:
	_speed = _speed + _acceleration
	global_position += _direction * _speed * _delta
	rotation = _direction.angle()

func spawn(new_position:Vector2, speed:float=1.0, life:float=1.0, accel:float=0.0, damage:int=1) -> void:
	#the position argument must be global!
	self.position = new_position
	_speed = speed
	_lifetime = life
	_acceleration = accel
	_damage = damage

func no_hit_destroy() -> void:
	queue_free()
	
func destroy() -> void:
	trail.hit = true
	Shake.shake(4.0, 0.2)
	AudioManager.play("res://Art/SFX/laserd.wav")
	var blast : ParticleAnimation = blast_scene.instantiate()
	get_parent().add_child(blast)
	blast.rotation = rotation
	blast.global_position = global_position
	blast.play()
	queue_free()

func _on_Bullet_body_entered(_body):
	if _body is Player and _body.is_in_group("Player"):
		_body.spell_collision()
	elif _body is Enemy and _body.is_in_group("Enemy"):
		_body.spell_collision()
	if !_hit:
		_hit = true
		destroy()

func get_direction() -> Vector2:
	return _direction
func get_speed() -> float:
	return _speed
func get_damage() -> int:
	return _damage

#setters
#func set_position(position) -> void:
#	self.position = position
func set_direction(direction:Vector2) -> void:
	_direction = direction
func set_lifetime(lifetime:float) -> void:
	_lifetime = lifetime
func set_velocity(speed:float) -> void:
	_speed = speed

func _on_hitbox_body_entered(body):
	if body is Enemy and body.is_in_group("Enemy"):
		body.spell_collision(self)
	elif body is Player and body.is_in_group("Player"):
		body.spell_collision(self)
	if !_hit:
		_hit = true
		destroy()

func _on_hitbox_area_entered(area):
	if area.get_parent().is_in_group("Spell"):
		if !_hit:
			_hit = true
			destroy()
