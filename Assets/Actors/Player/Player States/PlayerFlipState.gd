class_name PlayerFlipState
extends PlayerState

@export var idle_node : NodePath
@export var move_node : NodePath

@onready var idle_state : BaseState = get_node(idle_node)
@onready var move_state : BaseState = get_node(move_node)

var stored_velocity : Vector2

#slight pause in movement during flip
#start a timer?

func on_enter() -> void:
	super()
	stored_velocity = actor.velocity
	actor.velocity = Vector2.ZERO
	actor.flip()

func process(_delta) -> BaseState:
	if actor.flip_timer == 0.0:
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down"):
			return move_state
		return idle_state
	return null

func on_exit() -> void:
	super()
	actor.velocity = stored_velocity
