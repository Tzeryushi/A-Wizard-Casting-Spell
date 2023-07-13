class_name EnemyArrow
extends Node2D

@export var fade_threshold : float = 2500.0

@onready var arrow := $Arrow
@onready var raycast := $RayCast

var enemy : Enemy

func _process(_delta) -> void:
	#update based on enemy position
	if !is_instance_valid(enemy):
		destroy()
		return
	raycast.target_position = to_local(enemy.global_position)
	if raycast.is_colliding():
		var collision_point : Vector2 = raycast.get_collision_point()
		arrow.global_position = collision_point
		arrow.look_at(enemy.global_position)
		arrow.set("modulate:a", 1.0-min((collision_point.distance_to(enemy.global_position))/fade_threshold,1.0))
	else:
		arrow.set("modulate:a", 0.0)

func set_up_arrow(_enemy:Enemy) -> void:
	enemy = _enemy

func destroy() -> void:
	queue_free()
