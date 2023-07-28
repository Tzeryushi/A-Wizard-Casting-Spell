extends Node2D

func _process(delta):
	TextPopper.pop_text("[center][rainbow]Hooray!", Vector2(0,900), $Node2D, 2.0)

func _on_tutorial_button_pressed():
	SceneManager.switch_scene("MainMenu")

func _on_quit_button_pressed():
	SceneManager.quit_game()
