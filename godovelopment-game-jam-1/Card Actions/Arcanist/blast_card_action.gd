extends CardAction

func damage_player():
	player.shield_module.take_damage(1)
	return
