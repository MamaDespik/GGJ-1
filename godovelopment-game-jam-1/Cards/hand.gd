extends Node2D
class_name Hand

var hand_size:int = 3
var spacing:int = 100
var angle_spacing:float = PI/25
var cards:Array[Card]

signal card_played
signal empty

func _ready() -> void:
	return

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select"): #DEBUG
		add_card(load("res://Cards/card.tscn").instantiate())
	if event.is_action_pressed("cancel"): #DEBUG
		remove_card(cards[0])
	return

func update_hand():
	for child in get_children():
		remove_child(child)

	var start_position:int = -(spacing*(cards.size()-1))/2
	var start_angle:float = -(angle_spacing*(cards.size()-1))/2
	for i in cards.size():
		add_child(cards[i])
		cards[i].position.x = start_position + (spacing * i)
		cards[i].rotation = start_angle + (angle_spacing*i)
	return

func draw_card():
	#TODO
	return

func add_card(card:Card):
	cards.append(card)
	update_hand()
	return

func remove_card(card:Card):
	if cards.has(card):
		cards.erase(card)
	if get_children().has(card):
		remove_child(card)
	if cards.size() < 1:
		empty.emit()
	update_hand()
	return
