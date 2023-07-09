extends Node

@export var scenes : Dictionary = {}

var current_scene_name : String = ""


func _ready() -> void:
	var main_scene : String = ProjectSettings.get_setting("application/run/main_scene")
	current_scene_name = scenes.find_key(main_scene)

func add_scene(scene_name:String, scene_path:String) -> void:
	scenes[scene_name] = scene_path

func remove_scene(scene_name:String) -> void:
	scenes.erase(scene_name)

func switch_scene(scene_name:String) -> void:
	get_tree().change_scene_to_file(scenes[scene_name])

func restart_scene() -> void:
	get_tree().reload_current_scene()

func quit_game() -> void:
	get_tree().quit()
