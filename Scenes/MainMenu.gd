class_name MainMenu
extends BaseScene

func _on_button_pressed():
	SceneManager.switch_scene("NewLevel1")

func _on_quit_button_pressed():
	SceneManager.quit_game()

func _on_tutorial_button_pressed():
	SceneManager.switch_scene("Tutorial")

func _on_classic_button_pressed():
	SceneManager.switch_scene("Level0")
