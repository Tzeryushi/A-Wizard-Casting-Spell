extends BaseLevel

var level_done = false

func _on_area_2d_body_entered(_body):
	if _body is Player and _body.is_in_group("Player") and !level_done:
		level_done = true
		level_finish_popup()
