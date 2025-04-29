extends CardAction

var has_hit:bool = false

func _ready() -> void:
	super()
	shadow_offset = Vector2(0,-90)
	return

func trigger_combo():
	if !has_hit:
		has_hit = true
		combo()
	return

func _on_enemy_detector_area_entered(_area: Area2D) -> void:
	trigger_combo()
	return

func _on_enemy_detector_body_entered(_body: Node2D) -> void:
	trigger_combo()
	return
