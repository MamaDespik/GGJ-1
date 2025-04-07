extends State
class_name EnemyIdleState

@export var enemy_approaching_state:State
@export var enemy_attacking_state:State

var enemy_parent:Enemy

func enter():
	enemy_parent = parent
	return

func process_frame(delta:float) -> State:
	var distance_to_player = enemy_parent.position.distance_to(enemy_parent.player.position)
	if  distance_to_player <= enemy_parent.attack_range:
		return enemy_attacking_state
	if distance_to_player <= enemy_parent.sight_range:
		return enemy_approaching_state
	return
