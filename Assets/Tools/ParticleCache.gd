extends CanvasLayer

var particle1 = preload("res://Art/Particles/BulletSpark.tres")
var particle2 = preload("res://Art/Particles/PlayerSparkle.tres")
var particle3 = preload("res://Art/Particles/PuffProcessMaterial.tres")
var particle4 = preload("res://Art/Particles/ShootPuff.tres")
var particle5 = preload("res://Art/Particles/SporeTrail.tres")
var particle6 = preload("res://Art/Particles/WarpIn.tres")
var particle7 = preload("res://Art/Particles/WarpOut.tres")

var particle_array = [
	particle1, particle2, particle3,
	particle4, particle5, particle6,
	particle7
]

func _ready() -> void:
	for particle in particle_array:
		var instance := GPUParticles2D.new()
		instance.process_material = particle
		instance.one_shot = true
		instance.emitting = true
		self.add_child(instance)
