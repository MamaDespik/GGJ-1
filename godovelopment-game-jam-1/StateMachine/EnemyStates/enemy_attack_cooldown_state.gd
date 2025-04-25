extends State
class_name EnemyAttackCooldownState

@export var enemy_idle_state:State
@export var enemy_dying_state:State

var enemy_parent:Enemy

func enter():
	enemy_parent = parent
	enemy_parent.animation_player.play("cooldown")
	return

func exit():
	#enemy_parent.animation_player.play("RESET")
	return

func process_physics(_delta:float) -> State:
	if enemy_parent.health_module.current_health <= 0: return enemy_dying_state
	if !enemy_parent.animation_player.is_playing():
		return enemy_idle_state
	return
