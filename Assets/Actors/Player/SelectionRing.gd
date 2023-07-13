class_name SelectionRing
extends Sprite2D

@export var rotation_amount : float = 2.0

var pop_tween : Tween

func _ready() -> void:
	scale = Vector2(0,0)

func _process(_delta) -> void:
	rotation += rotation_amount*pow(Engine.time_scale,1.0/2.0)*_delta

func pop_in(time:float=0.1) -> void:
	if scale != Vector2.ZERO:
		scale = Vector2.ZERO
	if !is_instance_valid(self):
		return
	pop_tween = get_tree().create_tween()
	pop_tween.tween_property(self, "scale", Vector2(1.0,1.0), time*Engine.time_scale).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func pop_out(time:float=0.1) -> void:
	if scale != Vector2.ONE:
		scale = Vector2.ONE
	if !is_instance_valid(self):
		return
	pop_tween = get_tree().create_tween()
	pop_tween.tween_property(self, "scale", Vector2.ZERO, time*Engine.time_scale).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	await pop_tween.finished
	destroy()

func destroy() -> void:
	if is_instance_valid(pop_tween):
		pop_tween.kill()
	queue_free()
