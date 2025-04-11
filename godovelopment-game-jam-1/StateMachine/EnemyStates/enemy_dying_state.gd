extends State
class_name EnemyDyingState

var enemy_parent:Enemy

func enter():
	enemy_parent = parent
	#enemy_parent.disable_all_detection()
	enemy_parent.died.emit(enemy_parent)
	enemy_parent.animation_player.play("die")
	return
