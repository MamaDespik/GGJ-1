extends CardAction

func _ready() -> void:
	super()
	original_rotation = 0
	original_scale = Vector2(1,1)
	return

func shuffle():
	card.cards_container.shuffle_discard()
	return

func draw_hand():
	card.cards_container.draw_hand()
	return
