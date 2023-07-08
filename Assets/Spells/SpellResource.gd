class_name SpellResource
extends Resource

@export var base_spell : PackedScene
@export var green_spell : PackedScene
@export var green_body_spell : PackedScene
@export var blue_spell : PackedScene
@export var blue_body_spell : PackedScene
@export var red_spell : PackedScene
@export var red_body_spell : PackedScene

func get_spell(type:Globals.SPELLTYPE) -> PackedScene:
	match type:
		Globals.SPELLTYPE.GREEN:
			return green_spell
		Globals.SPELLTYPE.GREENBODY:
			return green_body_spell
		Globals.SPELLTYPE.BLUE:
			return green_spell
		Globals.SPELLTYPE.BLUEBODY:
			return green_spell
		Globals.SPELLTYPE.RED:
			return green_spell
		Globals.SPELLTYPE.REDBODY:
			return green_spell
	return base_spell
