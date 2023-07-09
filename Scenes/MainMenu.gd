class_name MainMenu
extends BaseScene

func _on_button_pressed():
	SceneManager.switch_scene("Level0")

func _on_quit_button_pressed():
	SceneManager.quit_game()

func _on_tutorial_button_pressed():
	SceneManager.switch_scene("Tutorial")
