extends CardAction

var original_position:Vector2

func _physics_process(_delta: float) -> void:
	if !original_position:
		original_position = global_position
		original_rotation = global_rotation
	global_position = original_position
	global_rotation = original_rotation
	try_track_shadow()
	return
