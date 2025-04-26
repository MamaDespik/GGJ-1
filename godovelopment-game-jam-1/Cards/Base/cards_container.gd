extends Node2D
class_name CardsContainer

@export var player:Player
@export var draw_pile: CardPile

var hand_empty:bool = false
var shuffle_speed_reduction:float = .4
var paused:bool = false

@onready var hand: Hand = %Hand
@onready var discard_pile: CardPile = %DiscardPile
@onready var shuffle_timer: Timer = $ShuffleTimer
@onready var shuffle_progress_bar: ProgressBar = $ShuffleProgressBar
@onready var draw_pile_position: Node2D = $DrawPilePosition

func _ready() -> void:
	player.reduce_shuffle_time.connect(_on_player_reduce_shuffle_time)
	draw_pile.reparent(draw_pile_position)
	draw_pile.position = Vector2.ZERO
	for card:Card in draw_pile.cards:
		card.player = player
		card.cards_container = self
		card.comboed.connect(_on_card_comboed)
	draw_pile.shuffle()
	draw_hand()
	hand.card_removed.connect(_on_hand_card_removed)
	hand.empty.connect(_on_hand_empty)
	return

func _process(_delta: float) -> void:
	if shuffle_timer.is_stopped():
		shuffle_progress_bar.value = 0
	else:
		var percentage:float = shuffle_timer.time_left/shuffle_timer.wait_time * 100
		shuffle_progress_bar.value = 100-percentage
	return

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		if !hand_empty:
			hand.check_empty()
		if hand_empty:
			shuffle_timer.start()
			player.speed_ratio -= shuffle_speed_reduction
	if event.is_action_released("select") and hand_empty:
		if !shuffle_timer.is_stopped():
			player.speed_ratio += shuffle_speed_reduction
		shuffle_timer.stop()
	return

func draw_hand():
	while hand.cards.size() < hand.hand_size and draw_pile.cards.size() > 0:
		hand.add_card(draw_pile.draw())
	return

func draw_new_card():
	if paused:return
	var drawn_card:Card = draw_pile.draw()
	if drawn_card:
		hand.add_card(drawn_card)
	else:
		hand.check_empty()
	return

func shuffle_discard():
	player.shield_module.take_damage(player.reshuffle_cost)
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
	player.speed_ratio += shuffle_speed_reduction
	var tween:Tween = create_tween()
	tween.tween_callback(shuffle_discard)
	tween.tween_interval(.5)
	for i in hand.hand_size:
		tween.tween_callback(draw_new_card).set_delay(.1)
	return

func _on_card_comboed(first_card:Card, second_card:Card):
	second_card.player = player
	second_card.cards_container = self
	second_card.animation_time = .1
	second_card.comboed.connect(_on_card_comboed)
	var index = hand.cards.find(first_card)
	if index < 0: index = 0
	hand.add_card_priority(second_card, index)
	return
	
func _on_player_reduce_shuffle_time():
	shuffle_timer.wait_time = .1
	return
