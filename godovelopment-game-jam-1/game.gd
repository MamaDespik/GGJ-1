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
		current_floor.floor_cleared.connect(_on_floor_cleared)
		floor_container.add_child(current_floor)
		cards_container.shuffle_discard()
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

func _on_floor_cleared(card:Card):
	cards_container.draw_pile.add_card(card)
	get_shop()
	return

func _on_shop_cleared():
	get_next_floor()
	return
