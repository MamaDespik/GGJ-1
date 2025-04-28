extends BossEnemy

@export var rat_enemy_scene:PackedScene

var rats:Array[Enemy]
var minimum_spawn_time:float = .5
var maximum_spawn_time:float = 3

@onready var rat_spawn_timer:Timer = $RatSpawnTimer

func _ready():
	super()
	rat_spawn_timer.wait_time = maximum_spawn_time
	rat_spawn_timer.start()
	var tween1:Tween = create_tween()
	tween1.set_loops()
	tween1.set_ease(Tween.EASE_IN_OUT)
	tween1.set_trans(Tween.TRANS_QUAD)
	tween1.tween_property(self, "scale:x", 1.05, .5)
	tween1.tween_property(self, "scale:x", .95, .7)
	var tween2:Tween = create_tween()
	tween2.set_loops()
	tween2.set_ease(Tween.EASE_IN_OUT)
	tween2.set_trans(Tween.TRANS_QUAD)
	tween2.tween_property(self, "scale:y", 1.05, .6)
	tween2.tween_property(self, "scale:y", .95, .8)
	return

func get_target():
	var x_target:float = randf_range(0,1920)
	var y_target:float = randf_range(0,1080)
	target = Vector2(x_target,y_target)
	return

func spawn_rat():
	var new_rat:Enemy = rat_enemy_scene.instantiate()
	rats.append(new_rat)
	new_rat.player = player
	new_rat.paused = false
	add_child(new_rat)
	new_rat.top_level = true
	new_rat.position = global_position
	return


func _on_died(_enemy):
	rat_spawn_timer.stop()
	for rat:Enemy in rats:
		if is_instance_valid(rat):
			rat.health_module.take_damage(999)
	return


func _on_rat_spawn_timer_timeout():
	spawn_rat()
	var health_ratio:float = float(health_module.current_health)/float(health_module.max_health)
	rat_spawn_timer.wait_time = lerp(minimum_spawn_time, maximum_spawn_time, health_ratio) + .0001
	rat_spawn_timer.start()
	return
