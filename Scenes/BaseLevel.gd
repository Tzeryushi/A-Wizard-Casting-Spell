class_name BaseLevel
extends Node2D

@export var finish_popup : PackedScene
@export var finish_popup_time : float = 2.0
@export var next_level : String = "MainMenu"

@onready var hud_layer := $HUD

var player_ref : Player
var enemy_count : int = 0

func _ready() -> void:
	player_setup()
	enemy_setup()

func _input(event) -> void:
	if event.is_action_pressed("reset_level"):
		SceneManager.restart_scene()

func player_setup():
	await get_tree().process_frame
	var tree = get_tree()
	if tree.has_group("Player"):
		player_ref = tree.get_nodes_in_group("Player")[0]
		player_ref.player_died.connect(_on_player_death)

func enemy_setup() -> void:
	#find each enemy in the scene, connect to death signal
	await get_tree().process_frame
	var tree = get_tree()
	if tree.has_group("Enemy"):
		for enemy in tree.get_nodes_in_group("Enemy"):
			enemy.destroyed.connect(_on_enemy_death)
			enemy_count += 1

func _on_player_death() -> void:
	#reset the level
	AudioManager.play("res://Art/SFX/error.wav")
	SceneManager.restart_scene()
	return

func _on_enemy_death() -> void:
	#check if clear!
	enemy_count -= 1
	if enemy_count <= 0:
		#level clear, fanfare and such
		level_finish_popup()
		return
	return

func level_finish_popup() -> void:
	var popup = finish_popup.instantiate()
	hud_layer.add_child(popup)
	popup.global_position = Vector2((get_viewport().content_scale_size/2).x, (get_viewport().content_scale_size*1.5).y)
	var tween = get_tree().create_tween()
	tween.tween_property(popup, "position", Vector2(get_viewport().content_scale_size/2), finish_popup_time/3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(popup, "position", Vector2(get_viewport().content_scale_size/2), finish_popup_time/3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(popup, "position", Vector2((get_viewport().content_scale_size/2).x, -(get_viewport().content_scale_size*1.5).y), finish_popup_time/3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await tween.finished
	SceneManager.switch_scene(next_level)
	
