extends CardAction

var speed_boost:float = 2000

func start_invulnerability():
	player.hurt_box.enabled = false
	var boost_vector:Vector2 = Vector2(speed_boost, 0)
	boost_vector = boost_vector.rotated(global_rotation)
	player.velocity += boost_vector
	player.boosting = true
	return

func stop_invulnerability():
	player.hurt_box.enabled = true
	player.boosting = false
	queue_free()
	return
