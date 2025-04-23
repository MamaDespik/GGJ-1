extends Card

@export var arc_angle:float = PI/4

func use():
	super()

	current_card_action = card_action_scene.instantiate()
	current_card_action.player = player
	current_card_action.card = self
	current_card_action.scale.y = player.direction
	current_card_action.rotate(arc_angle/2)
	player.card_actions.add_child(current_card_action)

	current_card_action = card_action_scene.instantiate()
	current_card_action.player = player
	current_card_action.card = self
	current_card_action.scale.y = player.direction
	current_card_action.rotate(-arc_angle/2)
	player.card_actions.add_child(current_card_action)
	return
