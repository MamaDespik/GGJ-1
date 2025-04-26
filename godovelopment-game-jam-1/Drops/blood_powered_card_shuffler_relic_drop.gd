extends Drop

func do_effect(player:Player):
	player.reduce_shuffle_time.emit()
	player.reshuffle_cost = 1
	return
