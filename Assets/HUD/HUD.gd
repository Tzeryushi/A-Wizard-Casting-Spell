class_name HUD
extends CanvasLayer

@onready var spell_holder := $"Full HUD/SpellHolder"
@onready var heart_holder := $"Full HUD/HeartHolder"

var player_ref : Player = null

func _ready() -> void:
	call_deferred("player_setup")

func player_setup():
	await get_tree().process_frame
	var tree = get_tree()
	if tree.has_group("Player"):
		player_ref = tree.get_nodes_in_group("Player")[0]
	if player_ref:
		player_ref.body_picked_up.connect(_on_body_picked_up)
		player_ref.body_casted.connect(_on_body_casted)
		player_ref.health_changed.connect(_on_health_changed)
		reset_HUD()
	else:
		print("Player not connected? Loaded late or not in scene!")

func reset_HUD() -> void:
	if player_ref:
		spell_holder.clear_wizards()
		heart_holder.set_hearts(player_ref.get_health())

func _on_body_picked_up(type:Globals.WIZARDTYPE) -> void:
	spell_holder.add_wizard(type)

func _on_body_casted() -> void:
	spell_holder.pop_wizard()

func _on_health_changed(value:int) -> void:
	heart_holder.set_hearts(value)
