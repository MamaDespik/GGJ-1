extends State
class_name IdlePlayerState

@export var walking_player_state: State
@export var dying_player_state:State

var player_parent:Player

func enter():
	player_parent = parent
	player_parent.start_animation("idle")
	return

func process_physics(delta: float) -> State:
	if player_parent.health_module.current_health <= 0: return dying_player_state
	var input:Vector2 = Vector2(
		Input.get_axis("move_left","move_right"),
		Input.get_axis("move_up","move_down"))
	if (input != Vector2.ZERO or player_parent.boosting) and \
	 player_parent.movement_disabled <= 0:
		return walking_player_state

	player_parent.apply_friction(delta)
	player_parent.move_and_slide()

	return
