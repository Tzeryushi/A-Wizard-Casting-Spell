extends TextureProgressBar

@export_subgroup("Colors")
@export var full_color : Color
@export var empty_color : Color
@export var refill_color : Color
@export_subgroup("Pulse Characteristics")
##The threshold (percentage) for when pulses begin
@export_range(0.0, 1.0, 0.01) var pulse_threshold : float
##The minimum time between bar warning pulses
@export_range(0.0, 3.0, 0.01) var pulse_cooldown : float
##The length of each pulse. If this is longer than the pulse cooldown, animations will get cut off.
@export_range(0.0, 1.0, 0.01) var pulse_time : float

@onready var timer := $Timer
@onready var pulse_rect := $PulseRect

var is_pulsing : bool = false
var last_percent : float = 1.0
var target_modulate : float

func _ready() -> void:
	timer.wait_time = pulse_cooldown
	pulse_rect.scale = Vector2.ONE
	pulse_rect.set_indexed("modulate:a", 0.0)
	target_modulate = modulate.a
	modulate.a = 0.0

func set_level(percent:float, is_refilling:bool=false) -> void:
	if percent == 1.0:
		var tween : Tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	else:
		var tween : Tween = create_tween()
		tween.tween_property(self, "modulate:a", target_modulate, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	percent = clampf(percent, 0.0, 1.0)
	value = percent*max_value
	if is_refilling:
		tint_progress = refill_color
		if is_pulsing:
			end_pulsing()
	else:
		tint_progress = full_color.lerp(empty_color, max(1.0-percent,0.0))
		if percent < pulse_threshold and !is_pulsing:
			start_pulsing()
		elif (percent > pulse_threshold or last_percent < percent) and is_pulsing:
			end_pulsing()
	last_percent = percent

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
	tween.tween_property(pulse_rect, "scale", Vector2(1.2, 4.6), pulse_time*Engine.time_scale).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(pulse_rect, "modulate:a", 0.0, pulse_time*Engine.time_scale).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

func _on_timer_timeout():
	if is_pulsing:
		pulse()
