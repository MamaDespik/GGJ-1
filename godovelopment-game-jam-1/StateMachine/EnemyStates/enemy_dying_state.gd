extends State
class_name EnemyDyingState

var enemy_parent:Enemy

func enter():
	enemy_parent = parent
	enemy_parent.disable_all_detection()
	var tween:Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(enemy_parent, "modulate", Color(1,1,1,0), 2)
	tween.tween_property(enemy_parent, "rotation", PI/2, 2)
	tween.set_parallel(false)
	tween.tween_callback(enemy_parent.queue_free)
	return
