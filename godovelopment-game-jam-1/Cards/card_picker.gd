extends Node2D
class_name CardPicker

@export var rare_card_rarity:float = .1
@export var rare_card_scenes:Array[PackedScene]
@export var uncommon_card_rarity:float = .3
@export var uncommon_card_scenes:Array[PackedScene]
@export var common_card_scenes:Array[PackedScene]
@export var new_choice_starting_cost:int
@export var new_choice_card_scene:PackedScene

var picked_card_scenes:Array[PackedScene]
@export var player:Player
var cost_increase:int = 2
var done_picking:bool = false
var current_cost:int
var current_ncc:NewChoiceCard

@onready var hand:Hand = $Hand

signal card_picked(Card)

func _ready():
	current_cost = new_choice_starting_cost
	hand.card_removed.connect(_on_hand_card_removed)
	player.gold_count = 100 #DEBUG
	pick_cards() #DEBUG
	return

func pick_cards():
	for i in 2:
		var picked_card_scene:PackedScene = pick_card()
		picked_card_scenes.append(picked_card_scene)
		var picked_card:Card = picked_card_scene.instantiate()
		picked_card.simulated = true
		hand.add_child(picked_card)
		hand.add_card(picked_card)
	if player.gold_count >= current_cost:
		var ncc:NewChoiceCard = new_choice_card_scene.instantiate()
		ncc.used.connect(_on_new_choice_card_used)
		ncc.gold_amount = current_cost
		hand.add_child(ncc)
		hand.add_card(ncc)
		current_ncc = ncc
	return

func pick_card() -> PackedScene:
	var picked_card:PackedScene
	if randf() < rare_card_rarity and rare_card_scenes.size() > 0:
		picked_card = rare_card_scenes.pick_random()
	elif randf() < uncommon_card_rarity and uncommon_card_scenes.size() > 0:
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
		if card is NewChoiceCard: return
		done_picking = true
		var cards_to_remove:Array[Card]
		for unpicked_card:Card in hand.cards:
			cards_to_remove.append(unpicked_card)
		for card_to_remove:Card in cards_to_remove:
			hand.remove_card(card_to_remove)
		card.simulated = false
		card_picked.emit(card)
		print("Picked ", card.card_title)
		reset_picker()
	else:
		card.queue_free()
	return

func _on_new_choice_card_used():
	player.gold_count -= current_cost
	current_cost *= cost_increase
	var picked_card_scene:PackedScene = pick_card()
	picked_card_scenes.append(picked_card_scene)
	var picked_card:Card = picked_card_scene.instantiate()
	picked_card.simulated = true
	hand.add_child(picked_card)
	hand.add_card(picked_card)
	if player.gold_count >= current_cost:
		var ncc:NewChoiceCard = new_choice_card_scene.instantiate()
		ncc.used.connect(_on_new_choice_card_used)
		ncc.gold_amount = current_cost
		hand.add_child(ncc)
		hand.add_card(ncc)
		current_ncc = ncc
	return
