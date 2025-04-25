extends Enemy


func get_target():
	var direction = (player.get_player_position() - global_position).normalized()
	target = global_position + (direction * 2000)
	return
