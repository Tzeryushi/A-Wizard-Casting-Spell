extends BaseSpell

@export var spell_split_time : float = 0.7
@export var no_hit_detection_time : float = 0.05
@export var split_amount : int = 2
@export var max_split_angle : float = PI/2

#var red_spell_node := preload("res://Assets/Spells/EnemySpells/RedSpell.tscn")

var spell_split_timer : float = spell_split_time
var child_no_hit_timer : float = no_hit_detection_time
var is_child : bool = false
var is_not_hitting : bool = false

func _process(_delta) -> void:
	if is_not_hitting:
		child_no_hit_timer -= _delta
		if child_no_hit_timer <= 0.0:
			is_not_hitting = false
	
	if !is_child:
		spell_split_timer -= _delta
		if spell_split_timer <= 0.0 and !_hit:
			split_spell()
		return
	
	#countdown to lifetime.
	_lifetime -= _delta
	if _lifetime <= 0.0 and !_hit:
		no_hit_destroy()

func destroy() -> void:
	trail.hit = true
	Shake.shake(4.0, 0.2)
	AudioManager.play("res://Art/SFX/laserd.wav")
	var blast : ParticleAnimation = blast_scene.instantiate()
	get_parent().add_child(blast)
	blast.rotation = rotation
	blast.global_position = global_position
	blast.play()
	queue_free()

func set_as_child() -> void:
	is_not_hitting = true
	is_child = true

func split_spell() -> void:
	var sub_fraction : float = max_split_angle/(split_amount-1)
	for clone in range(0, split_amount):
		var new_direction : Vector2 = _direction.rotated((sub_fraction*clone)-(max_split_angle/2))
		var new_spell = (load(scene_file_path) as PackedScene).instantiate()
		new_spell.set_as_child()
		new_spell.spawn(global_position, _speed, _lifetime, _acceleration)
		new_spell.set_direction(new_direction)
		get_tree().current_scene.add_child(new_spell)
	is_not_hitting = true
	destroy()
#need to make an exception for when new spells are instanced

func _on_hitbox_area_entered(area):
	if area.is_in_group("RedSplitSpell"):
		if is_not_hitting:
			return
	if area.get_parent().is_in_group("Spell"):
		if !_hit:
			_hit = true
			destroy()
