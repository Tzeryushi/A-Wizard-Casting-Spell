class_name Player
extends Actor

@export var _spell_list : SpellResource
@export var flip_time = 0.25
@export var _spell_restriction_time : float = 0.3

@onready var mouse := $Mouse
@onready var physics_collider := $PhysicsCollider
@onready var restriction_timer := $SpellRestrictionTimer
@onready var spell_spawn_location := $SpellSpawnLocation

var spell_stack : Array[BodyModel]

var flip_timer : float = 0.0
var can_fire_spell : bool = true

func _ready() -> void:
	state_manager.init_state(self)
	restriction_timer.wait_time = _spell_restriction_time

func _unhandled_input(_event) -> void:
	state_manager.input(_event)
	if Input.is_action_just_pressed("shoot"):
		shoot()

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
	print("Pew-pew! add particle effects!")
	if !spell_stack.is_empty() and can_fire_spell:
		can_fire_spell = false
		var spell_info : BodyModel = spell_stack.pop_back()
		var new_spell : BaseSpell = _spell_list.get_spell(spell_info.spell_type).instantiate()
		var look_rotation = get_mouse_direction()
		new_spell.spawn(center.global_position+(spell_spawn_location.position.x*look_rotation), spell_info.speed, spell_info.lifetime, spell_info.acceleration, spell_info.damage)
		new_spell.set_direction(look_rotation.normalized())
		get_parent().add_child(new_spell)
		restriction_timer.start()
	return

func spell_collision(spell:BaseSpell) -> void:
	#should trigger world state changes
	#for now, call a global?
	print("trigger restart! you should be dead.")
	return

func sprite_rotation() -> void:
	var current_angle = get_mouse_direction().angle()
	animations.rotation = current_angle
	
func get_mouse_direction() -> Vector2:
	var mouse_pos = get_viewport().get_mouse_position()
	var shot_direction_vector = (mouse_pos - center.global_position)
	shot_direction_vector = shot_direction_vector/shot_direction_vector.length()
	return shot_direction_vector.normalized()

func flip() -> void:
	flip_timer = flip_time
	var enemy_ref : Enemy = mouse.get_flippable_enemy()
	await get_tree().create_timer(flip_time/2).timeout
	physics_collider.disabled = true
	var current_position : Vector2 = center.global_position
	var current_enemy_position : Vector2 = enemy_ref.center.global_position
	global_position = current_enemy_position
	enemy_ref.global_position = current_position
	mouse.force_update_position()
	physics_collider.disabled = false

func pickup_body(body:BaseBody) -> void:
	spell_stack.append(body.get_body())
	print("Wizard body added! Update UI!")

func can_flip() -> bool:
	#placeholder for check when player cannot flip
	if mouse.can_flip():
		return true
	return false


func _on_spell_restriction_timer_timeout():
	can_fire_spell = true
