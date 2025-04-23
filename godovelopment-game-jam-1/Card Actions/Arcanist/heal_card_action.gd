extends CardAction


func  heal_player():
	player.health_module.heal(1)
	return
