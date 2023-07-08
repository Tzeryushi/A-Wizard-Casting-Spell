class_name PlayerMoveState
extends PlayerState

@export var idle_node : NodePath
@export var flip_node : NodePath

@onready var idle_state : BaseState = get_node(idle_node)
@onready var flip_state : BaseState = get_node(flip_node)

func input(_event:InputEvent) -> BaseState:
	#check if possible to flip first
	
	if Input.is_action_just_pressed("flip") and actor.can_flip():
		return flip_state
	return null

func physics_process(_delta:float) -> BaseState:
	var direction : Vector2 = get_move_direction()
	actor.move(direction, _delta)
	if direction == Vector2.ZERO:
		return idle_state
	return null
