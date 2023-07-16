extends BaseSpell

@export var spell_split_time : float = 0.7
@export var no_hit_detection_time : float = 0.1

var spell_split_timer : float = spell_split_time
var child_no_hit_timer : float = no_hit_detection_time
var is_child : bool = false
const split_amount : int = 2

func _process(_delta) -> void:
	if !is_child:
		spell_split_timer -= _delta
		if spell_split_timer <= 0.0 and !_hit:
			split_spell()
		return
	
	#countdown to lifetime.
	_lifetime -= _delta
	if _lifetime <= 0.0 and !_hit:
		no_hit_destroy()

func set_as_child() -> void:
	is_child = true

func split_spell() -> void:
	return

#need to make an exception for when new spells are instanced
