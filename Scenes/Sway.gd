extends Node2D

@export var size_change : float = 0.2
@export var rotate : float = 7.0
@export var time : float = 1.0

var initial_scale : Vector2

func _ready() -> void:
	initial_scale = scale
	_start_tweens()

func _start_tweens() -> void:
	_start_tween()
	await get_tree().create_timer(time/2.0).timeout
	_start_tween2()

func _start_tween() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", initial_scale + Vector2(size_change, size_change), time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await tween.finished
	size_change = -size_change
	_start_tween()

func _start_tween2() -> void:
	var tween = create_tween()
	tween.parallel().tween_property(self, "rotation_degrees", rotate, time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await tween.finished
	rotate = -rotate
	_start_tween2()
