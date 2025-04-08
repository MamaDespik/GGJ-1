extends Node2D
class_name CardsContainer

@export var player:Player

var hand_empty:bool = false

@onready var draw_pile: CardPile = $DrawPile
@onready var hand: Hand = $Hand
@onready var discard_pile: CardPile = $DiscardPile
@onready var shuffle_timer: Timer = $ShuffleTimer

func _ready() -> void:
	for i in 10:
		var new_card:Card = load("res://Cards/block_card.tscn").instantiate()
		new_card.position = draw_pile.position
		draw_pile.add_card(new_card)
		new_card.used.connect(_on_card_used)
	draw_pile.shuffle()
	for i in hand.hand_size:
		hand.add_card(draw_pile.draw())
	hand.card_removed.connect(_on_hand_card_removed)
	hand.empty.connect(_on_hand_empty)
	return

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select") and hand_empty:
		shuffle_timer.start()
	if event.is_action_released("select") and hand_empty:
		shuffle_timer.stop()
	return

func draw_new_card():
	var drawn_card:Card = draw_pile.draw()
	if drawn_card:
		hand.add_card(drawn_card)
	else:
		hand.check_empty()
	return

func shuffle_discard():
	for i in discard_pile.cards.size():
		draw_pile.add_card(discard_pile.draw())
	draw_pile.shuffle()
	return

func _on_hand_card_removed(card:Card):
	var tween:Tween = create_tween()
	tween.tween_callback(discard_pile.add_card.bind(card, true))
	tween.tween_callback(draw_new_card).set_delay(.5)
	return

func _on_hand_empty():
	hand_empty = true
	return

func _on_shuffle_timer_timeout() -> void:
	hand_empty = false
	var tween:Tween = create_tween()
	tween.tween_callback(shuffle_discard)
	tween.tween_interval(1)
	for i in hand.hand_size:
		tween.tween_callback(draw_new_card).set_delay(.1)
	return

func _on_card_used(card_action:CardAction):
	player.card_actions.add_child(card_action)
	return
