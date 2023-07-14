class_name BaseBody
extends RigidBody2D

@export var body_info : BodyModel
@export var damping : float = 2.0

func _ready() -> void:
	linear_damp = damping

func get_body() -> BodyModel:
	return body_info

func destruct() -> void:
	queue_free()

func _on_pickup_hitbox_body_entered(_body):
	if _body is Player and _body.is_in_group("Player"):
		if _body.can_pickup_body():
			_body.pickup_body(self)
			destruct()
		else:
			_body.pickup_fail()
