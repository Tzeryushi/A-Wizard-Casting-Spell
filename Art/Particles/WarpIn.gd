extends ParticleAnimation

@onready var warp := $Warp

func _process(_delta) -> void:
	if !warp.emitting:
		finished.emit()
		queue_free()

func play() -> void:
	warp.emitting = true

func stop() -> void:
	warp.emitting = false
