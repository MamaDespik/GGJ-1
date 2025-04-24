extends CardAction

func shuffle():
	card.cards_container.shuffle_discard()
	return

func draw_hand():
	card.cards_container.draw_hand()
	return
