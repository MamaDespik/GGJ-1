extends State
class_name EnemyAttackingState

@export var enemy_idle_state:State
@export var enemy_dying_state:State

var enemy_parent:Enemy

func enter():
	enemy_parent = parent
	enemy_parent.get_target()
	enemy_parent.animation_player.play("attack")
	return

func exit():
	#enemy_parent.animation_player.play("RESET")
	return

func process_physics(delta:float) -> State:
	if enemy_parent.health_module.current_health <= 0: return enemy_dying_state
	if !enemy_parent.animation_player.is_playing():
		return enemy_idle_state

	#approach target
	var global_current := enemy_parent.global_position
	var global_target := enemy_parent.target
	var movement_factor:float = enemy_parent.speed * delta
	var motion:Vector2 = global_current.move_toward(global_target, movement_factor) - global_current

	enemy_parent.move_and_collide(motion)
	return
