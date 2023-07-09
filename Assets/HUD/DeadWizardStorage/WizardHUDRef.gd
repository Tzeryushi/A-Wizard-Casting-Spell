class_name WizardHUDRef
extends Resource

@export var green_wizard : PackedScene
@export var blue_wizard : PackedScene
@export var red_wizard : PackedScene
@export var black_wizard : PackedScene
@export var generic_wizard : PackedScene

func get_wizard_image(type:Globals.WIZARDTYPE) -> PackedScene:
	match type:
		Globals.WIZARDTYPE.GREEN:
			return green_wizard
		Globals.WIZARDTYPE.BLUE:
			return blue_wizard
		Globals.WIZARDTYPE.RED:
			return red_wizard
		Globals.WIZARDTYPE.BLACK:
			return black_wizard
		_:
			return generic_wizard
