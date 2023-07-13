extends Node2D

@export var current_selection_scene : PackedScene

var valid_flip_array : Array[Enemy]
var selection_ring : SelectionRing

func _process(_delta) -> void:
	global_position = get_global_mouse_position()

func glow_enemies() -> void:
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		if is_instance_valid(enemy):
			enemy.glow()

func unglow_enemies() -> void:
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		if is_instance_valid(enemy):
			enemy.unglow()

func _on_mouse_box_area_entered(area):
	var parent_node = area.get_parent()
	if parent_node is Enemy and parent_node.is_in_group("Enemy") and parent_node.is_flippable():
		if !valid_flip_array.is_empty():
			remove_selector()	#remove the last candidate
		valid_flip_array.append(parent_node)
		set_selector(parent_node)

func _on_mouse_box_area_exited(area):
	var parent_node = area.get_parent()
	if parent_node is Enemy and parent_node.is_in_group("Enemy"):
		if parent_node == valid_flip_array.back():
			remove_selector()
			if valid_flip_array.size() != 1:
				set_selector(valid_flip_array.back())
		valid_flip_array.erase(parent_node)

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

func set_selector(enemy:Node) -> void:
	if is_instance_valid(selection_ring):
		selection_ring.pop_out()
	selection_ring = current_selection_scene.instantiate()
	enemy.add_child(selection_ring)
	selection_ring.pop_in()

func remove_selector() -> void:
	if !is_instance_valid(selection_ring):
		return
	selection_ring.call_deferred("pop_out")
	
func force_update_position() -> void:
	global_position = get_global_mouse_position()
