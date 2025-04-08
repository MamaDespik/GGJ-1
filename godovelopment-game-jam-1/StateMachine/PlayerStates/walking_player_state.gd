extends State
class_name WalkingPlayerState

@export var idle_player_state:State
@export var dying_player_state:State

var player_parent:Player

func enter():
	player_parent = parent
	player_parent.start_animation("walk_down")
	return

func process_physics(delta: float) -> State:
	if player_parent.health_module.current_health <= 0: return dying_player_state

	var input_axis_h:float = Input.get_axis("move_left","move_right")
	var input_axis_v:float = Input.get_axis("move_up","move_down")
	player_parent.handle_acceleration(input_axis_h, input_axis_v, delta)

	if input_axis_h > 0:
		if abs(input_axis_h) > abs(input_axis_v): #right
			player_parent.start_animation("walk_sideways")
			player_parent.direction = 1
			player_parent.card_actions.rotation = 0
	if input_axis_h < 0:
		if abs(input_axis_h) > abs(input_axis_v): #left
			player_parent.start_animation("walk_sideways")
			player_parent.direction = -1
			player_parent.card_actions.rotation = 180
	if input_axis_v > 0:
		if abs(input_axis_v) > abs(input_axis_h):
			player_parent.start_animation("walk_down")
			player_parent.card_actions.rotation = 90
	if input_axis_v < 0:
		if abs(input_axis_v) > abs(input_axis_h):
			player_parent.start_animation("walk_up")
			player_parent.card_actions.rotation = -90

	player_parent.move_and_slide()

	if input_axis_h == 0 and input_axis_v == 0:
		return idle_player_state

	return

#func process_input(_event: InputEvent) -> State:
	##handle using a card
	#return
