extends CardAction

var original_position:Vector2
var original_rotation:float

func _physics_process(_delta: float) -> void:
	if !original_position:
		original_position = global_position
		original_rotation = global_rotation
	global_position = original_position
	global_rotation = original_rotation
	return
