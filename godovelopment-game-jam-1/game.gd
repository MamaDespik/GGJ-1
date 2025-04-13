extends Node2D
class_name Game

@export var region_scenes:Array[PackedScene]

var current_region:Region
var current_floor:Floor

@onready var player = $Player
@onready var floor_container = $FloorContainer
@onready var cards_container: CardsContainer = $CardsContainer

func _ready():
	current_region = region_scenes.pop_front().instantiate()
	get_next_floor()
	return

func get_next_floor():
	if current_region.floor_lengths.size() > 0:
		if current_floor: current_floor.queue_free()
		#TODO transition
		current_floor = current_region.get_floor()
		current_floor.player = player
		current_floor.start_choice.connect(_on_floor_start_choice)
		current_floor.floor_cleared.connect(_on_floor_cleared)
		floor_container.add_child(current_floor)
		cards_container.draw_hand()
	else:
		if region_scenes.size() > 0:
			current_region.queue_free()
			current_region = region_scenes.pop_front().instantiate()
			get_next_floor()
		else:
			#TODO
			print("You won the game!")
	return

func get_shop():
	current_floor.queue_free()
	current_floor = current_region.get_shop()
	current_floor.player = player
	current_floor.floor_cleared.connect(_on_shop_cleared)
	floor_container.add_child(current_floor)
	return

func clear_hand():
	var cards_to_remove:Array[Card]
	for card_in_hand:Card in cards_container.hand.cards:
		cards_to_remove.append(card_in_hand)
	for card:Card in cards_to_remove:
		card.discard()
	return

func _on_floor_cleared(card:Card):
	card.used.connect(cards_container._on_card_used)
	var tween:Tween = create_tween()
	tween.tween_callback(cards_container.draw_pile.add_card.bind(card))
	tween.tween_interval(1)
	tween.tween_callback(cards_container.shuffle_discard)
	tween.tween_property(cards_container, "paused", false, 0)
	tween.tween_interval(.2)
	tween.tween_callback(get_shop)
	return

func _on_shop_cleared():
	get_next_floor()
	return

func _on_floor_start_choice():
	var tween:Tween = create_tween()
	tween.tween_property(cards_container, "paused", true, 0)
	tween.tween_interval(1.5)
	tween.tween_callback(clear_hand)
	tween.tween_callback(current_floor.card_picker.pick_cards)
	return
