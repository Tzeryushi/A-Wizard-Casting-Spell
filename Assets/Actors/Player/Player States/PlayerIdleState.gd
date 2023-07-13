class_name PlayerIdleState
extends PlayerState

@export var move_node : NodePath
@export var flip_node : NodePath

@onready var move_state : BaseState = get_node(move_node)
@onready var flip_state : BaseState = get_node(flip_node)

func input(_event:InputEvent) -> BaseState:
	if Input.is_action_just_released("flip") and actor.can_flip():
		return flip_state
	return null

func process(_delta:float) -> BaseState:
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down"):
		return move_state
	return null

func physics_process(_delta:float) -> BaseState:
	actor.idle(_delta)
	return null
