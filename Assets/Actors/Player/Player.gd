class_name Player
extends Actor

@export var _spell_list : SpellResource
@export var _enemy_arrow_scene : PackedScene
@export var flip_time = 0.2
@export var _spell_restriction_time : float = 0.3
@export var _max_spells : int = 4
@export var _slow_time_amount : float = 1.0
@export var _ouchie_index : Array[String]

@onready var mouse := $Mouse
@onready var physics_collider := $PhysicsCollider
@onready var restriction_timer := $SpellRestrictionTimer
@onready var spell_spawn_location := $SpellSpawnLocation
@onready var camera := $Camera

var spell_stack : Array[BodyModel]
var arrows : Array[EnemyArrow]
var slow_tween : Tween

var flip_timer : float = 0.0
var slow_timer : float = _slow_time_amount
var can_fire_spell : bool = true
var is_invincible : bool = false
var is_slowing_time : bool = false
var random_generator: RandomNumberGenerator

signal body_picked_up(type:Globals.WIZARDTYPE)
signal body_casted
signal player_died
signal max_spells

func _ready() -> void:
	if Engine.time_scale != 1.0:
		Engine.time_scale = 1.0
	state_manager.init_state(self)
	restriction_timer.wait_time = _spell_restriction_time
	Shake.set_camera(camera)
	random_generator = RandomNumberGenerator.new()
	call_deferred("_process_frame_setup")

func _process_frame_setup() -> void:
	mouse.unglow_enemies()
	
	#add arrows
	for scene_enemy in get_tree().get_nodes_in_group("Enemy"):
		if is_instance_valid(scene_enemy):
			var new_arrow = _enemy_arrow_scene.instantiate()
			new_arrow.set_up_arrow(scene_enemy)
			arrows.append(new_arrow)
			add_child(new_arrow)
	
func _unhandled_input(_event) -> void:
	state_manager.input(_event)
	if Input.is_action_just_pressed("shoot"):
		shoot()
	if Input.is_action_just_pressed("flip"):
		flip_slow_time()
	elif Input.is_action_just_released("flip") and is_slowing_time == true:
		flip_unslow_time()

func _process(_delta):
	state_manager.process(_delta)
	flip_timer = max(flip_timer-_delta, 0.0)
	#handle sprite rotations here?
	sprite_rotation()

func _physics_process(_delta):
	state_manager.physics_process(_delta)
	if flip_timer > 0.0:
		return
	move_and_slide()

func idle(_delta:float) -> void:
	velocity.x = move_toward(velocity.x, 0, decceleration)
	velocity.y = move_toward(velocity.y, 0, decceleration)

func move(_direction, _delta:float) -> void:
	move_direction = _direction
	velocity.x = move_toward(velocity.x, max_movement_speed*_direction.x, acceleration)
	velocity.y = move_toward(velocity.y, max_movement_speed*_direction.y, acceleration)

func shoot() -> void:
	#handling shoot here - not parcatcht of states?
	if !spell_stack.is_empty() and can_fire_spell:
		can_fire_spell = false
		var spell_info : BodyModel = spell_stack.pop_back()
		var new_spell : BaseSpell = _spell_list.get_spell(spell_info.spell_type).instantiate()
		var look_rotation = get_mouse_direction()
		new_spell.spawn(center.global_position+(spell_spawn_location.position.x*look_rotation), spell_info.speed, spell_info.lifetime, spell_info.acceleration, spell_info.damage)
		new_spell.set_direction(look_rotation.normalized())
		get_parent().add_child(new_spell)
		restriction_timer.start()
		body_casted.emit()
		TextPopper.pop_text("[center][rainbow]Wizardio!", Vector2(0,0), self, 1.0, 1.0)
		animations.play("shooting")
		await animations.animation_finished
		animations.play("idle")
	return

func player_death() -> void:
	player_died.emit()
	if is_instance_valid(slow_tween):
		slow_tween.kill()

func spell_collision(spell:BaseSpell) -> void:
	#should trigger world state changes
	#for now, call a global?
	if is_invincible:
		return
	
	Shake.shake(6.0, 0.2)
	TextPopper.pop_text("[center][color=#EC9A29]"+_ouchie_index.pick_random(), Vector2(0,0), self, 1.0, 1.0, 50, 10)
	var new_health = health - spell.get_damage()
	set_health(new_health)
	if health <= 0:
		player_death()
	else:
		velocity += spell.get_direction().normalized()*200
		animations.play("hurt")
		await animations.animation_finished
		animations.play("idle")

func sprite_rotation() -> void:
	var _current_angle = get_mouse_direction().angle()
	#animations.rotation = _current_angle
	
func get_mouse_direction() -> Vector2:
	var mouse_pos = get_global_mouse_position()
	var shot_direction_vector = (mouse_pos - center.global_position)
	shot_direction_vector = shot_direction_vector/shot_direction_vector.length()
	return shot_direction_vector.normalized()

func flip_slow_time() -> void:
	if is_slowing_time:
		return
	is_slowing_time = true
	mouse.glow_enemies()
	slow_tween = get_tree().create_tween()
	slow_tween.tween_property(Engine, "time_scale", 0.1, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	slow_tween.tween_property(Engine, "time_scale", 1.0, 1.8)
	await slow_tween.finished
	slow_tween.kill()

func flip_unslow_time() -> void:
	if !is_slowing_time:
		return
	if is_instance_valid(slow_tween):
		slow_tween.kill()
	is_slowing_time = false
	mouse.unglow_enemies()
	var tween = get_tree().create_tween()
	tween.tween_property(Engine, "time_scale", 1.0, 0.2).set_trans(Tween.TRANS_LINEAR)
	return

func flip() -> void:
	flip_timer = flip_time
	var enemy_ref : Enemy = mouse.get_flippable_enemy()
	is_invincible = true
	physics_collider.disabled = true
	
	scale_in_and_out(flip_time)	#smooth shrink
	enemy_ref.scale_in_and_out(flip_time)
	
	AudioManager.play("res://Art/SFX/spell2.wav")
	
	await get_tree().create_timer(flip_time/2).timeout
	var current_position : Vector2 = center.global_position
	var current_enemy_position : Vector2 = enemy_ref.center.global_position
	global_position = current_enemy_position
	enemy_ref.global_position = current_position
	mouse.force_update_position()
	
	await get_tree().create_timer(flip_time/4).timeout
	is_invincible = false
	physics_collider.disabled = false

func can_pickup_body() -> bool:
	if spell_stack.size() >= _max_spells:
		return false
	return true

func pickup_body(body:BaseBody) -> void:
	AudioManager.play("res://Art/SFX/spell1.wav")
	spell_stack.append(body.get_body())
	body_picked_up.emit(spell_stack.back().wizard_type)

func can_flip() -> bool:
	#placeholder for check when player cannot flip
	if mouse.can_flip():
		return true
	return false

func _on_spell_restriction_timer_timeout():
	can_fire_spell = true
