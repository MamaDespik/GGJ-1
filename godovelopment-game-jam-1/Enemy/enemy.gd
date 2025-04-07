extends StaticBody2D
class_name Enemy

@onready var health_module: HealthModule = $HealthModule

func _ready() -> void:
	health_module.died.connect(_on_died)

func _on_died():
	var tween:Tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,0), 2)
	tween.tween_callback(queue_free)
	return
