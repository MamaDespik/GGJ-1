extends State
class_name WalkingPlayerState

@export var idle_player_state:State

func enter():
	var player_parent:Player = parent
	player_parent.start_animation("walk_down")
	return

func process_physics(delta: float) -> State:
	var player_parent:Player = parent

	var input_axis_h:float = Input.get_axis("move_left","move_right")
	var input_axis_v:float = Input.get_axis("move_up","move_down")
	player_parent.handle_acceleration(input_axis_h, input_axis_v, delta)

	if input_axis_h > 0:
		if abs(input_axis_h) > abs(input_axis_v):
			player_parent.start_animation("walk_right")
	if input_axis_h < 0:
		if abs(input_axis_h) > abs(input_axis_v):
			player_parent.start_animation("walk_left")
	if input_axis_v > 0:
		if abs(input_axis_v) > abs(input_axis_h):
			player_parent.start_animation("walk_down")
	if input_axis_v < 0:
		if abs(input_axis_v) > abs(input_axis_h):
			player_parent.start_animation("walk_up")

	player_parent.move_and_slide()

	if input_axis_h == 0 and input_axis_v == 0:
		return idle_player_state

	return

func process_input(_event: InputEvent) -> State:
	#handle using a card
	return
