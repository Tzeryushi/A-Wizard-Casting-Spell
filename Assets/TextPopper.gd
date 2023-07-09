extends Node2D

@export var pop_block : PackedScene

func pop_text(text:String, position:Vector2, calling_node:Node, size:float=1.0, velocity:float=600.0, accel:float=1300.0) -> void:
	var popper = pop_block.instantiate()
	calling_node.add_child(popper)
	popper.scale = popper.scale*size
	popper.position = position
	popper.set_text(text)
	
	#var tween = get_tree().create_tween()
	#tween.tween_property(popper, "modulate.a", 0.0, 0.9).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	#await tween.finished
	await get_tree().create_timer(0.9).timeout
	if is_instance_valid(popper):
		popper.queue_free()
