extends State
class_name IdlePlayerState

@export var walking_player_state: State

func enter():
	var player_parent:Player = parent
	player_parent.start_animation("idle")
	return

func process_physics(delta: float) -> State:
	var player_parent:Player = parent

	player_parent.apply_friction(delta)
	player_parent.move_and_slide()

	if Input.get_axis("move_left","move_right") != 0 or \
		Input.get_axis("move_up", "move_down") != 0:
		return walking_player_state
	return

func process_input(_event: InputEvent) -> State:
	#handle using a card
	return
