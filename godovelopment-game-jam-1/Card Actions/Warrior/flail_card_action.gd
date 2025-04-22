extends CardAction

var original_rotation:float

func _physics_process(_delta: float) -> void:
	if !original_rotation:
		original_rotation = global_rotation
	global_rotation = original_rotation
	return
