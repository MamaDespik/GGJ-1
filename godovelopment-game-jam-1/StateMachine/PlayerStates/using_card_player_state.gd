extends State
class_name UsingCardPlayerState

@export var idle_player_state: State
@export var dying_player_state: State

var player_parent:Player

func enter():
	player_parent = parent
	player_parent.start_animation("using_card")
	return


func process_physics(delta: float) -> State:
	if player_parent.health_module.current_health <= 0: return dying_player_state
	if !player_parent.using_card: return idle_player_state

	player_parent.handle_acceleration(Vector2.ZERO, delta)
	return
