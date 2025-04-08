extends State
class_name EnemyAttackingState

@export var enemy_idle_state:State
@export var enemy_approaching_state:State
@export var enemy_dying_state:State

var enemy_parent:Enemy

func enter():
	enemy_parent = parent
	return

func exit():
	enemy_parent.animation_player.play("RESET")
	return

func process_physics(_delta:float) -> State:
	if enemy_parent.health_module.current_health <= 0: return enemy_dying_state
	if !enemy_parent.animation_player.current_animation == "attack":
		var distance_to_player = enemy_parent.position.distance_to(enemy_parent.player.position)
		if distance_to_player > enemy_parent.sight_range:
			return enemy_idle_state
		if distance_to_player > enemy_parent.attack_range:
			return enemy_approaching_state

		enemy_parent.animation_player.play("attack")
	return
