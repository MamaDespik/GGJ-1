extends CardAction


func _process(_delta: float) -> void:
	global_rotation = 0
	return

func start_blocking_player():
	player.movement_disabled += 1
	player.hurt_box.enabled = false
	return

func stop_blocking_player():
	player.movement_disabled -= 1
	player.hurt_box.enabled = true
	return
