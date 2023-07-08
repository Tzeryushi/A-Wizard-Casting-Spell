class_name Enemy
extends Actor

@export var _spell_scene : PackedScene
@export var _body_scene : PackedScene
@export var _spell_restriction_time : float = 5.0
@export var _spell_velocity : float = 250.0
@export var _spell_lifetime : float = 10.0
@export var _spell_acceleration : float = 5.0
@export var _distance_to_keep : float = 400.0

@export var navigation_agent : NavigationAgent2D

@onready var line_of_sight := $SightLine
@onready var line_of_follow := $FollowLine
@onready var restriction_timer := $SpellRestrictionTimer
@onready var spell_spawn_location := $SpellSpawnLocation
@onready var glow_sprite := $GlowSprite

var player_ref : Player = null
var player_seen : bool = false
var player_following : bool = false
var can_fire_spell : bool = true

func _ready() -> void:
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	call_deferred("actor_setup")

func actor_setup():
	await get_tree().process_frame
	var tree = get_tree()
	if tree.has_group("Player"):
		player_ref = tree.get_nodes_in_group("Player")[0]
	restriction_timer.wait_time = _spell_restriction_time
	

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

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func shoot() -> void:
	#shoot spell
	if player_seen and can_fire_spell:
		var new_spell : BaseSpell = _spell_scene.instantiate()
		var look_rotation = Vector2(cos(line_of_sight.rotation), sin(line_of_sight.rotation))
		new_spell.spawn(center.global_position+(spell_spawn_location.position.x*look_rotation), _spell_velocity, _spell_lifetime, _spell_acceleration)
		new_spell.set_direction(look_rotation.normalized())
		get_parent().add_child(new_spell)
		can_fire_spell = false
		restriction_timer.start()
	return

func spell_collision(spell:BaseSpell) -> void:
	health = health - spell.get_damage()
	print(health, spell.get_damage())
	if health <= 0:
		leave_body(spell.get_direction().normalized()*spell.get_speed())
		destruct()
	else:
		velocity += spell.get_direction().normalized()*200
	return

func leave_body(impulse:Vector2) -> void:
	var new_body : BaseBody = _body_scene.instantiate()
	new_body.global_position = center.global_position
	new_body.apply_impulse(impulse)
	get_parent().call_deferred("add_child", new_body)

func is_player_seen() -> bool:
	var collider = line_of_sight.get_collider()
	if collider and collider.is_in_group("Player"):
		return true
	return false

func should_follow() -> bool:
	var collider = line_of_follow.get_collider()
	if collider and collider.is_in_group("Player"):
		return true
	return false

func destruct() -> void:
	queue_free()

func glow() -> void:
	#should glow to show flippability
	glow_sprite.material.set("shader_parameter/cutoff_one", 0.715)
	return

func unglow() -> void:
	glow_sprite.material.set("shader_parameter/cutoff_one", 2.0)
	return

func is_flippable() -> bool:
	
	return true

func _on_spell_restriction_timer_timeout():
	can_fire_spell = true
