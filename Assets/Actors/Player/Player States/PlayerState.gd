class_name PlayerState
extends BaseState

@export var state_type : Globals.PLAYERSTATE

var actor: Player
var move_last : Vector2 = Vector2.ZERO

func get_move_direction() -> Vector2:
	#gets a direction from input
	#the last direction pressed gets priority
	var value_x = sign(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
#	if Input.is_action_pressed("move_left") and Input.is_action_pressed("move_right"):
#		#code here cannot be collapsed due to priority rules
#		if Input.is_action_just_pressed("move_left"):
#			value_x = -1
#		elif Input.is_action_just_pressed("move_right"):
#			value_x = 1
#		elif move_last.x == -1:
#			value_x = -1
#		elif move_last.x == 1:
#			value_x = 1
#	move_last.x = value_x
#
	var value_y = sign(Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
#	if Input.is_action_pressed("move_up") and Input.is_action_pressed("move_down"):
#		#code here cannot be collapsed due to priority rules
#		if Input.is_action_just_pressed("move_up"):
#			value_y = -1
#		elif Input.is_action_just_pressed("move_down"):
#			value_y = 1
#		elif move_last.y == -1:
#			value_y = -1
#		elif move_last.y == 1:
#			value_y = 1
#	move_last.y = value_y
	return Vector2(value_x, value_y).normalized()
