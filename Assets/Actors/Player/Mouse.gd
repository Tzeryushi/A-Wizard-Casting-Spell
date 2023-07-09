extends Node2D

var valid_flip_array : Array[Enemy]

func _process(_delta) -> void:
	global_position = get_global_mouse_position()

func _on_mouse_box_area_entered(area):
	var parent_node = area.get_parent()
	if parent_node is Enemy and parent_node.is_in_group("Enemy") and parent_node.is_flippable():
		if !valid_flip_array.is_empty():
			valid_flip_array.back().unglow()
		valid_flip_array.append(parent_node)
		parent_node.glow()

func _on_mouse_box_area_exited(area):
	var parent_node = area.get_parent()
	if parent_node is Enemy and parent_node.is_in_group("Enemy"):
		parent_node.unglow()
		valid_flip_array.erase(parent_node)
		if !valid_flip_array.is_empty():
			valid_flip_array.back().glow()

func can_flip() -> bool:
	if !valid_flip_array.is_empty():
		for enemy in valid_flip_array:
			if enemy.is_flippable():
				return true
	return false

func get_flippable_enemy() -> Enemy:
	#returns null if cannot
	if !can_flip():
		return null
	return valid_flip_array.back()

func force_update_position() -> void:
	global_position = get_global_mouse_position()
