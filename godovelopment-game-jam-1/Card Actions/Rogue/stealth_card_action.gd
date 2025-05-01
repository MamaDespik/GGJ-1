extends CardAction

var player_footsteps_volume:float

@export var stealth_visual:bool:
	set(value):
		set_visuals(value)
		stealth_visual = value
		return

@export var stealth_practical:bool:
	set(value):
		set_practical(value)
		stealth_practical = value
		return

func set_visuals(value:bool):
	if player:
		player.set_stealth_visuals(value)
	return

func set_practical(value:bool):
	if player:
		player.set_stealth_practical(value)
	return

func mute_footsteps():
	player_footsteps_volume = player.footsteps.volume_db
	player.footsteps.volume_db = -20
	return

func restore_footsteps():
	player.footsteps.volume_db = player_footsteps_volume
	return
