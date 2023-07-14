extends Node2D

@onready var spell_timer := $Timer
@onready var progress_wheel := $ProgressWheel

func _process(_delta):
	if spell_timer.time_left > 0.0:
		progress_wheel.value = int(((spell_timer.wait_time-spell_timer.time_left)/spell_timer.wait_time)*progress_wheel.max_value)

func start_spell_timer(time:float) -> void:
	spell_timer.wait_time = time
	spell_timer.start()
	
func pause_spell_timer() -> void:
	spell_timer.paused = true

func unpause_spell_timer() -> void:
	spell_timer.pause = false

func _on_timer_timeout():
	progress_wheel.value = 0.0
