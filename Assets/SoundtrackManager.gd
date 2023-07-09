extends Node

@onready var player := $AudioStreamPlayer

enum THEME { YULG }

func _ready() -> void:
	play(THEME.YULG)

#dictionary to store all soundtracks with enum key
var track_list = {
	THEME.YULG:preload("res://Art/yulg.wav"),
}

const TRACK_HINT: Dictionary = {
	YULG = THEME.YULG, # equivalent to: "APPLE": APPLE
}

var loaded_theme : int = THEME.YULG

func play(theme:THEME):
	player.stop()
	loaded_theme = theme
	if track_list.has(loaded_theme):
		player.stream = track_list[loaded_theme]
		player.play()

func reset():
	player.play(0.0)

func play_at(time:float):
	#TODO: Catch for playing at unavailable time
	player.play(time)

func stop():
	if player.playing:
		player.stop()

func resume():
	if !player.playing:
		player.play()
