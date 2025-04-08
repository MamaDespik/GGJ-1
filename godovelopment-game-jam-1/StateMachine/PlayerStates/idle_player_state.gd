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

	player_parent.apply_friction(delta)
	player_parent.move_and_slide()

	if Input.get_axis("move_left","move_right") != 0 or \
		Input.get_axis("move_up", "move_down") != 0:
		return walking_player_state
	return
