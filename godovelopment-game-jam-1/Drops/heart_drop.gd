extends Drop

func do_effect(player:Player):
	player.health_module.heal(1)
	return
