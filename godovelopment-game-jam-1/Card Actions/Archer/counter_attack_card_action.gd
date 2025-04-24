extends CardAction

func _ready() -> void:
	look_at(player.target_position)
	super()
	return

func stop_blocking_player():
	player.movement_disabled -= 1
	player.damage_negation -= 1
	return
