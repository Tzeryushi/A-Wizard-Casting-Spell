class_name Enemy
extends Actor

enum ANIMATION_TYPE {IDLE, ATTACK, HURT, WINDUP, MOVE, WINDUP_MOVE}

@export var _spell_scene : PackedScene
@export var _body_scene : PackedScene
@export var _spell_restriction_time : float = 5.0
@export var _spell_velocity : float = 250.0
@export var _spell_lifetime : float = 10.0
@export var _spell_acceleration : float = 5.0
@export var _distance_to_keep : float = 400.0
@export var _flippable : bool = true
@export var _move_animation_threshold : float = 30.0

@export var navigation_agent : NavigationAgent2D

@onready var line_of_sight := $SightLine
@onready var block_check_line_r := $SightLine/EnvCheckLineR
@onready var block_check_line_l := $SightLine/EnvCheckLineL
@onready var line_of_follow := $FollowLine
@onready var restriction_timer := $SpellRestrictionTimer
@onready var spell_spawn_location := $SpellSpawnLocation
@onready var glow_sprite := $GlowSprite
@onready var spell_timer_display := $SpellTimerDisplay

var player_ref : Player = null
var player_seen : bool = false
var player_following : bool = false
var can_fire_spell : bool = true
var has_been_killed : bool = false
var current_animation : ANIMATION_TYPE

signal destroyed
signal attack_animation_finished
signal hurt_animation_finished

func _ready() -> void:
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	var generator = RandomNumberGenerator.new()
	animations.rotation = generator.randf_range(-PI, PI)
	animations.animation_finished.connect(animation_finished)
	
	block_check_line_r.target_position.x = line_of_sight.target_position.x
	block_check_line_l.target_position.x = line_of_sight.target_position.x
	
	call_deferred("actor_setup")

func actor_setup():
	await get_tree().process_frame
	var tree = get_tree()
	if tree.has_group("Player"):
		player_ref = tree.get_nodes_in_group("Player")[0]
	restriction_timer.wait_time = _spell_restriction_time

func _process(_delta) -> void:
	if can_fire_spell:
		if !(current_animation == ANIMATION_TYPE.WINDUP or current_animation == ANIMATION_TYPE.WINDUP_MOVE):
			if velocity.length() > _move_animation_threshold:
				play_animation_windup_move()
			else:
				play_animation_windup()
		elif current_animation == ANIMATION_TYPE.WINDUP_MOVE and velocity.length() < _move_animation_threshold:
			play_animation_windup()
		elif current_animation == ANIMATION_TYPE.WINDUP and velocity.length() > _move_animation_threshold:
			play_animation_windup_move()
	

func _physics_process(_delta) -> void:
	#state_manager.physics_process(_delta)
	run_sight_follow_logic()	#this chould set the navigation target
	shoot()
	
	set_movement_values()
	move_and_slide()

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
			if (player_ref.global_position-global_position).length() > _distance_to_keep:
				set_movement_target(player_ref.global_position)
			else:
				var position_to_move : Vector2 = (global_position - player_ref.global_position).normalized()*_distance_to_keep
				set_movement_target(global_position + position_to_move)
				
			animations.look_at(player_ref.global_position)
		else:
			set_movement_target(global_position)

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

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func shoot() -> void:
	#shoot spell
	if player_seen and can_fire_spell and !is_shot_obstructed():
		var new_spell : BaseSpell = _spell_scene.instantiate()
		var look_rotation = Vector2(cos(line_of_sight.rotation), sin(line_of_sight.rotation))
		new_spell.spawn(center.global_position+(spell_spawn_location.position.x*look_rotation), _spell_velocity, _spell_lifetime, _spell_acceleration)
		new_spell.set_direction(look_rotation.normalized())
		get_parent().add_child(new_spell)
		can_fire_spell = false
		start_spell_timers()
		
		#handle animation
		play_animation_attack()
	return

func spell_collision(spell:BaseSpell) -> void:
	health = health - spell.get_damage()
	TextPopper.root_pop_text("[center][color=#A8201A]-"+str(spell.get_damage()), global_position, self, 1.0, 1.0, 50, 10)
	if health <= 0:
		if !has_been_killed:
			has_been_killed = true
			leave_body(spell.get_direction().normalized()*spell.get_speed())
		else:
			TextPopper.root_jolt_text("[center][rainbow]OVERKILL!!", 50.0, global_position, 1.0, 2.0, 45, 10)
		destruct()
	else:
		velocity += spell.get_direction().normalized()*200
	play_animation_hurt()
	return

func leave_body(impulse:Vector2) -> void:
	var new_body : BaseBody = _body_scene.instantiate()
	new_body.global_position = center.global_position
	new_body.apply_impulse(impulse)
	get_parent().call_deferred("add_child", new_body)

func is_shot_obstructed() -> bool:
	#checks if shot will clip wall soon after being fired
	var collider_r = block_check_line_r.get_collider()
	var collider_l = block_check_line_l.get_collider()
	if (collider_r and (collider_r.is_in_group("Environment"))):
		var ray_length : float = (block_check_line_r.get_collision_point()-block_check_line_r.global_position).length()
		if ray_length < (player_ref.global_position-global_position).length():
			return true
	if (collider_l and (collider_l.is_in_group("Environment"))):
		var ray_length : float = (block_check_line_l.get_collision_point()-block_check_line_l.global_position).length()
		if ray_length < (player_ref.global_position-global_position).length():
			return true
	return false

func check_player_seen() -> void:
	var was_seen = player_seen
	var collider = line_of_sight.get_collider()
	if collider and (collider.is_in_group("Player") or collider.is_in_group("PlayerSight")):
		player_seen = true
	else:
		player_seen = false
	if !was_seen and player_seen and !player_following:
		TextPopper.jolt_text("[center][color=red]!!", self, 50.0, Vector2.ZERO, 1.0, 1.0, 40, 8)

func check_should_follow() -> void:
	var was_following = player_following
	var collider = line_of_follow.get_collider()
	if collider and (collider.is_in_group("Player") or collider.is_in_group("PlayerSight")):
		player_following = true
	else:
		player_following = false
	if was_following and !player_following:
		TextPopper.jolt_text("[center][color=purple]??", self, 50.0)

func destruct() -> void:
	destroyed.emit()
	AudioManager.play("res://Art/SFX/gnomewoo.wav")
	queue_free()

func glow() -> void:
	#should glow to show flippability
	glow_sprite.material.set("shader_parameter/cutoff_one", 0.715)
	return

func unglow() -> void:
	glow_sprite.material.set("shader_parameter/cutoff_one", 2.0)
	return

func is_flippable() -> bool:
	
	return _flippable

func start_spell_timers() -> void:
	restriction_timer.start()
	spell_timer_display.start_spell_timer(restriction_timer.wait_time)

func _on_spell_restriction_timer_timeout():
	can_fire_spell = true

func play_animation_idle() -> void:
	current_animation = ANIMATION_TYPE.IDLE
	animations.play("idle")
	return
func play_animation_attack() -> void:
	current_animation = ANIMATION_TYPE.ATTACK
	animations.play("attack")
	await animations.animation_finished
	attack_animation_finished.emit()
	return
func play_animation_hurt() -> void:
	current_animation = ANIMATION_TYPE.HURT
	animations.play("hurt")
	await animations.animation_finished
	hurt_animation_finished.emit()
	return
func play_animation_windup() -> void:
	current_animation = ANIMATION_TYPE.WINDUP
	animations.play("windup")
	return
func play_animation_move() -> void:
	current_animation = ANIMATION_TYPE.MOVE
	animations.play("idle")
	return
func play_animation_windup_move() -> void:
	current_animation = ANIMATION_TYPE.WINDUP_MOVE
	animations.play("windup")
	return
func animation_finished() -> void:
	if current_animation == ANIMATION_TYPE.ATTACK or current_animation == ANIMATION_TYPE.HURT:
		if velocity.length() > _move_animation_threshold:
			play_animation_move()
		else:
			play_animation_idle()
