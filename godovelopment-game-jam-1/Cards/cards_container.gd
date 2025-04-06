extends Node2D
class_name CardsContainer

var count:int = 1 #DEBUG

@onready var draw_pile: CardPile = $DrawPile
@onready var hand: Hand = $Hand
@onready var discard_pile: CardPile = $DiscardPile

func _ready() -> void:
	for i in 10:
		var new_card:Card = load("res://Cards/Card.tscn").instantiate()
		new_card.card_title = str(count)
		count += 1
		new_card.position = draw_pile.position
		draw_pile.add_card(new_card)
	for i in hand.hand_size:
		hand.add_card(draw_pile.draw())
	hand.card_removed.connect(_on_hand_card_removed)
	hand.empty.connect(_on_hand_empty)
	return

func _on_hand_card_removed(card:Card):
	discard_pile.add_card(card, true)
	var drawn_card = draw_pile.draw()
	if drawn_card:
		hand.add_card(drawn_card)
	return

func _on_hand_empty():
	for i in discard_pile.cards.size():
		draw_pile.add_card(discard_pile.draw())
	draw_pile.shuffle()
	for i in hand.hand_size:
		hand.add_card(draw_pile.draw())
	return
