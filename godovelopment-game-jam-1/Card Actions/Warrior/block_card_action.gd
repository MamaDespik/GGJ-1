extends CardAction


func _ready() -> void:
	super()
	original_rotation = 0
	original_scale = Vector2(1,1)
	return

func _input(event):
	if event.is_action_released("select"):
		animation_player.play("stop")
	return

func start_blocking_player():
	stop_player_movement()
	player.damage_negation += 1
	return

func stop_blocking_player():
	restore_player_movement()
	player.damage_negation -= 1
	return
