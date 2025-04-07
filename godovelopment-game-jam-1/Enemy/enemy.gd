extends StaticBody2D
class_name Enemy

@onready var health_module: HealthModule = $HealthModule

func _on_health_module_died() -> void:
	var tween:Tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,0), 2)
	tween.tween_callback(queue_free)
	return

func _on_hurt_box_hurt(damage: int) -> void:
	health_module.adjust_health(-damage)
	return
