extends Control

@onready var container = $ColorRect/VBoxContainer

func _input(event) -> void:
	if event.is_action_pressed("pause"):
		pause_unpause()

func pause_unpause() -> void:
	var new_state = not get_tree().paused
	get_tree().paused = new_state
	visible = new_state

func _on_resume_pressed():
	pause_unpause()

func _on_main_menu_pressed():
	pause_unpause()
	SceneManager.switch_scene("MainMenu")

func _on_quit_pressed():
	SceneManager.quit_game()
