extends Node2D
class_name CardPicker

@export var rare_card_rarity:float = .1
@export var rare_card_scenes:Array[PackedScene]
@export var uncommon_card_rarity:float = .3
@export var uncommon_card_scenes:Array[PackedScene]
@export var common_card_scenes:Array[PackedScene]
@export var new_choice_starting_cost:int

var picked_card_scenes:Array[PackedScene]
@export var player:Player
var cost_increase:int = 2
var done_picking:bool = false
var current_cost:int 

@onready var hand:Hand = $Hand
@onready var new_choice_button:Button = $NewChoiceButton

signal card_picked(Card)

func _ready():
	current_cost = new_choice_starting_cost
	hand.card_removed.connect(_on_hand_card_removed)
	pick_cards() #DEBUG
	return

func pick_cards():
	if player.gold_count < current_cost:
		new_choice_button.disabled = true
	for i in 2:
		var picked_card_scene:PackedScene = pick_card()
		picked_card_scenes.append(picked_card_scene)
		hand.add_card(picked_card_scene.instantiate())
	return
	
func pick_card() -> PackedScene:
	var picked_card:PackedScene
	if randf() < rare_card_rarity:
		picked_card = rare_card_scenes.pick_random()
	elif randf() < uncommon_card_rarity:
		picked_card = uncommon_card_scenes.pick_random()
	else:
		picked_card = common_card_scenes.pick_random()
		
	if picked_card_scenes.has(picked_card):
		picked_card = pick_card()
		
	return picked_card

func reset_picker():
	picked_card_scenes.clear()
	done_picking = false
	current_cost = new_choice_starting_cost
	return

func _on_hand_card_removed(card:Card):
	if !done_picking:
		done_picking = true
		for unpicked_card:Card in hand.cards:
			hand.remove_card(unpicked_card)
	else:
		card.queue_free()
	if hand.cards.size() <= 0:
		card_picked.emit(card)
		reset_picker()
	return

func _on_new_choice_button_pressed():
	player.gold_count -= current_cost
	current_cost *= cost_increase
	var picked_card_scene:PackedScene = pick_card()
	picked_card_scenes.append(picked_card_scene)
	hand.add_card(picked_card_scene.instantiate())
	if player.gold_count < current_cost:
		new_choice_button.disabled = true
	return
