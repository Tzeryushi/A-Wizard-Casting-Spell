extends Node2D

class_name BaseScene

func start_up() -> void:
	#start_up is to be called by the main layer when a scene is first loaded.
	pass
	
func on_reveal() -> void:
	#on_reveal is meant to be called each time a scene is transitioned in and become visible to the player.
	pass

func clean_up() -> void:
	#clean_up is to be called BEFORE a scene node is removed.
	pass
