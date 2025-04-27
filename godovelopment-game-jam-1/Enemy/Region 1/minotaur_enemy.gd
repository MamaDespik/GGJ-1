extends Enemy


func get_target():
	var direction = (player.get_player_position() - global_position).normalized()
	target = global_position + (direction * 2000)
	sprite_2d.flip_h = (global_position.x - target.x) < 0
	return
