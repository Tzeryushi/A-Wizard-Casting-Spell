extends Control

@export var heart_scene : PackedScene

@onready var heart_container := $HBoxContainer

var heart_stack : Array

func clear_hearts() -> void:
	for i in heart_stack.size():
		heart_stack.pop_back().queue_free()

func add_heart() -> void:
	var new_heart = heart_scene.instantiate()
	heart_container.add_child(new_heart)
	heart_stack.append(new_heart)

func set_hearts(count:int) -> void:
	clear_hearts()
	if count < 0:
		return
	for i in count:
		add_heart()
		
