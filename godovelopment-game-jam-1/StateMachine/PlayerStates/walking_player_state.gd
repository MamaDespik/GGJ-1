extends State
class_name WalkingPlayerState

@export var idle_player_state:State
@export var dying_player_state:State
@export var using_card_player_state:State

var player_parent:Player

func enter():
	player_parent = parent
	player_parent.start_animation("walk_down")
	return

func process_physics(delta: float) -> State:
	if player_parent.health_module.current_health <= 0: return dying_player_state
	if player_parent.using_card: return using_card_player_state

	var input:Vector2 = Vector2(
		Input.get_axis("move_left","move_right"),
		Input.get_axis("move_up","move_down"))
	player_parent.handle_acceleration(input, delta)
	if (input == Vector2.ZERO and !player_parent.boosting) or\
	 player_parent.movement_disabled > 0:
		return idle_player_state
	if input != Vector2.ZERO:
		var angle:float = Vector2(0,0).angle_to_point(input)
		player_parent.card_actions.rotation = angle
	if input.x > 0:
		if abs(input.x) > abs(input.y): #right
			player_parent.start_animation("walk_sideways")
			player_parent.set_direction(1)
	if input.x < 0:
		if abs(input.x) > abs(input.y): #left
			player_parent.start_animation("walk_sideways")
			player_parent.set_direction(-1)
	if input.y > 0:
		if abs(input.y) > abs(input.x):
			player_parent.start_animation("walk_down")
	if input.y < 0:
		if abs(input.y) > abs(input.x):
			player_parent.start_animation("walk_up")

	player_parent.move_and_slide()
	return
