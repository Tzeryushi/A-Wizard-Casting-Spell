extends Control

@onready var slider := $HSlider

func _ready():
	AudioServer.set_bus_volume_db(0, -10.0)
	var vol = AudioServer.get_bus_volume_db(0)
	slider.value = vol

func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)
