extends Node2D

@export var velocity_init := 600.0
@export var grav_accel := 1300.0

@onready var pop_text := $PopText

var velocity := Vector2.ZERO
func _ready() -> void:
	var direction = Vector2(0, -1)
	direction = Vector2(direction.x*cos(randf_range(-PI/3,PI/3))-direction.y*sin(randf_range(-PI/3,PI/3)), direction.x*sin(randf_range(-PI/3,PI/3))+direction.y*cos(randf_range(-PI/3,PI/3)))
	velocity = direction * velocity_init

func _process(delta) -> void:
	velocity += Vector2(0, grav_accel) * delta
	pop_text.position += velocity * delta

func set_text(text) -> void:
	pop_text.set_text(text)
