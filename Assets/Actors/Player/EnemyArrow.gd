class_name EnemyArrow
extends Node2D

@export var fade_threshold : float = 2500.0
@export var visible_padding : float = 80.0

@onready var arrow := $Arrow
@onready var raycast := $RayCast

var enemy : Enemy

func _process(_delta) -> void:
	#update based on enemy position
	if !is_instance_valid(enemy):
		destroy()
		return
	raycast.target_position = to_local(enemy.global_position)
	#raycast.look_at(enemy.global_position)
	var collision_point : Vector2 = raycast.get_collision_point()
	if raycast.is_colliding() and (collision_point.distance_to(enemy.global_position)) > visible_padding:
		arrow.global_position = collision_point
		arrow.look_at(enemy.global_position)
		var distance_percent = 1.0-min((collision_point.distance_to(enemy.global_position))/fade_threshold,1.0)
		arrow.set_indexed("modulate:a", distance_percent)
		arrow.scale = Vector2(distance_percent, distance_percent)
	else:
		arrow.set_indexed("modulate:a", 0.0)

func set_up_arrow(_enemy:Enemy) -> void:
	enemy = _enemy

func destroy() -> void:
	queue_free()
