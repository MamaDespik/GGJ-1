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


func _on_area_2d_area_entered(_area: Area2D) -> void:
	queue_free()
	return

func _on_area_2d_body_entered(_body: Node2D) -> void:
	queue_free()
	return
