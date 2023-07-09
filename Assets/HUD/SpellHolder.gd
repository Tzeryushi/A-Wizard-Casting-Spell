extends Control

@export var wizard_refs : WizardHUDRef

@onready var holding := $Storage/DeadWizardHolding

var wizard_stack : Array

func add_wizard(type:Globals.WIZARDTYPE) -> void:
	var scene : PackedScene = wizard_refs.get_wizard_image(type)
	var new_wizard_image = scene.instantiate()
	holding.add_child(new_wizard_image)
	wizard_stack.append(new_wizard_image)

func pop_wizard() -> void:
	var wizard_image = wizard_stack.pop_back()
	wizard_image.queue_free()

func clear_wizards() -> void:
	for wizard_image in wizard_stack:
		wizard_image.queue_free()
