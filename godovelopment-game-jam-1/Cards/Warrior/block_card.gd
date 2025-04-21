extends Card


func _input(event):
	if event.is_action_released("select"):
		if is_using:
			if !simulated: current_card_action.animation_player.play("stop")
			discard()
	super(event)
	return
