extends ParticleAnimation

@onready var sparks := $Blast

func _process(_delta) -> void:
	if !sparks.emitting:
		finished.emit()
		queue_free()

func play() -> void:
	sparks.emitting = true

func stop() -> void:
	sparks.emitting = false
