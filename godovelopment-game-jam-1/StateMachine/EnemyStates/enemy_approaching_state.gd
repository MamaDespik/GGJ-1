extends State
class_name EnemyApproachingState

@export var enemy_idle_state:State
@export var enemy_attacking_state:State
@export var enemy_dying_state:State

var enemy_parent:Enemy

func enter():
	enemy_parent = parent
	return

func process_physics(delta:float) -> State:
	if enemy_parent.health_module.current_health <= 0: return enemy_dying_state
	var distance_to_player = enemy_parent.global_position.distance_to(enemy_parent.get_player_position())
	if distance_to_player <= enemy_parent.attack_range:
		return enemy_attacking_state
	if distance_to_player > enemy_parent.sight_range:
		return enemy_idle_state

	#approach player
	var global_current := enemy_parent.global_position
	var global_target := enemy_parent.get_player_position()
	var movement_factor:float = enemy_parent.speed * delta
	var motion:Vector2 = global_current.move_toward(global_target, movement_factor) - global_current

	enemy_parent.move_and_collide(motion)
	return
