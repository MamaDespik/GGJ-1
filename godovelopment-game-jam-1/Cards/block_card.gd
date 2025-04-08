extends Card

var is_using:bool = false

func _input(event):
	if event.is_action_pressed("select"):
		if is_highlighted:
			use()
			is_using = true
			is_highlighted = false
	if event.is_action_released("select"):
		if is_using:
			current_card_action.animation_player.play("stop")
			discard()
			is_using = false
	super(event)
	return
