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
			return blue_spell
		Globals.SPELLTYPE.BLUEBODY:
			return blue_body_spell
		Globals.SPELLTYPE.RED:
			return red_spell
		Globals.SPELLTYPE.REDBODY:
			return red_body_spell
	return base_spell
