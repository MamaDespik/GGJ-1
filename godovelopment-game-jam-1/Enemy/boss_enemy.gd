extends Enemy

var boss_health_module_scene:PackedScene = preload("res://Modules/boss_health_module.tscn")

func _ready() -> void:
	var max_health:int = health_module.max_health
	health_module.queue_free()
	health_module = boss_health_module_scene.instantiate()
	health_module.max_health = max_health
	#health_module.current_health = max_health
	add_child(health_module)
	super()
	return
