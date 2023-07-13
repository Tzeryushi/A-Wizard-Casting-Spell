extends Node2D

@export var pop_block : PackedScene

func pop_text(text:String, _position:Vector2, calling_node:Node, size:float=1.0, time:float=1.0, font_size:int=30, outline_size:int=7) -> void:
	var popper = pop_block.instantiate()
	calling_node.add_child(popper)
	popper.scale = popper.scale*size
	popper.position = _position
	popper.set_text(text,font_size,outline_size)
	popper.set_pop_time(time)
	
	await get_tree().create_timer(time/2).timeout
	if !is_instance_valid(popper):
		return
	var tween = create_tween()
	tween.tween_property(popper, "modulate:a", 0.0, time/2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	await tween.finished
	#await get_tree().create_timer(0.9).timeout
	if is_instance_valid(popper):
		popper.queue_free()

func root_pop_text(text:String, _position:Vector2, _calling_node:Node, size:float=1.0, time:float=1.0, font_size:int=30, outline_size:int=7) -> void:
	var popper = pop_block.instantiate()
	get_tree().get_root().add_child(popper)
	popper.scale = popper.scale*size
	popper.position = _position
	popper.set_text(text,font_size,outline_size)
	popper.set_pop_time(time)
	
	await get_tree().create_timer(time/2).timeout
	if !is_instance_valid(popper):
		return
	var tween = create_tween()
	tween.tween_property(popper, "modulate:a", 0.0, time/2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	await tween.finished
	#await get_tree().create_timer(0.9).timeout
	if is_instance_valid(popper):
		popper.queue_free()
