extends TileMap

func _ready() -> void:
	transform.origin = Vector2(get_viewport().content_scale_size/2) - Vector2(get_used_rect().size*32/2)
