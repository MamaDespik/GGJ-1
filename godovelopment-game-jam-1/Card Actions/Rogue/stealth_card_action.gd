extends CardAction

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
