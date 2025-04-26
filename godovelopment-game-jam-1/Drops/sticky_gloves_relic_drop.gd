extends Drop

func do_effect(player:Player):
	player.increase_hand_size.emit()
	return
