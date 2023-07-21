extends TextureProgressBar

@export var full_color : Color
@export var empty_color : Color
@export var refill_color : Color
@export_range(0.0, 1.0, 0.01) var pulse_threshold : float
@export var pulse_cooldown : float #the minimum time between bar warning pulses
@export var pulse_time : float

@onready var timer := $Timer
@onready var pulse_rect := $PulseRect

var is_pulsing : bool = false

func _ready() -> void:
	timer.wait_time = pulse_cooldown
	pulse_rect.scale = Vector2.ONE
	pulse_rect.set_indexed("modulate:a", modulate.a)

func set_level(percent:float, is_refilling:bool=false) -> void:
	if percent == 1.0:
		visible = false
	else:
		visible = true
	percent = clampf(percent, 0.0, 1.0)
	value = percent*max_value
	if is_refilling:
		tint_progress = refill_color
	else:
		tint_progress = full_color.lerp(empty_color, max(1.0-percent,0.0))
		if percent < pulse_threshold and !is_pulsing:
			start_pulsing()
		elif is_pulsing:
			end_pulsing()

func start_pulsing() -> void:
	is_pulsing = true
	pulse()
	timer.start()
	
func end_pulsing() -> void:
	is_pulsing = false
	timer.stop()

func pulse() -> void:
	var tween : Tween = create_tween()
	pulse_rect.scale = Vector2.ONE
	pulse_rect.set_indexed("modulate:a", modulate.a)
	tween.tween_property(pulse_rect, "scale", Vector2(1.2, 1.2), pulse_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(pulse_rect, "modulate:a", 0.0, pulse_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

func _on_timer_timeout():
	if is_pulsing:
		pulse()
