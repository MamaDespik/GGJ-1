extends State
class_name EnemyIdleState

@export var enemy_approaching_state:State
@export var enemy_attacking_state:State
@export var enemy_dying_state:State

var enemy_parent:Enemy

func enter():
	enemy_parent = parent
	return

func process_frame(_delta:float) -> State:
	if enemy_parent.health_module.current_health <= 0: return enemy_dying_state
	var distance_to_player = enemy_parent.global_position.distance_to(enemy_parent.get_player_position())
	if  distance_to_player <= enemy_parent.attack_range:
		return enemy_attacking_state
	if distance_to_player <= enemy_parent.sight_range:
		return enemy_approaching_state
	return
