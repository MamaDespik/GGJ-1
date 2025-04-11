extends Drop

func do_effect(player:Player):
	player.shield_module.add_shield(1)
	return
