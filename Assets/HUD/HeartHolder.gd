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
		
	call_deferred("pulse_bar")

func pulse_heart(heart:Node) -> void:
	if !is_instance_valid(heart):
		return
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(heart, "scale", Vector2(1.4,1.4), 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(heart, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func pulse_bar() -> void:
	scale = Vector2.ONE
	if !is_instance_valid(self):
		return
	for heart in heart_container.get_children():
		if is_instance_valid(heart) and !heart.is_queued_for_deletion():
			var tween : Tween = get_tree().create_tween()
			tween.tween_property(heart, "scale", Vector2(1.4,1.4), 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
			tween.tween_property(heart, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
