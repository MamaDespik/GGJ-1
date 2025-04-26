extends CardAction


func _process(_delta: float) -> void:
	global_rotation = 0
	return

func shuffle():
	card.cards_container.shuffle_discard()
	return

func draw_hand():
	card.cards_container.draw_hand()
	return
