extends Node2D
class_name Hand

var hand_size:int = 3
var spacing:int = 100
var angle_spacing:float = PI/25
var cards:Array[Card]
var highlight_index:int = -1

signal card_played(card:Card)
signal empty

func _ready() -> void:
	return

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select"): #DEBUG
		add_card(load("res://Cards/card.tscn").instantiate())
	if event.is_action_pressed("cancel"): #DEBUG
		remove_card(cards[0])
	if event.is_action_pressed("change_highlight_left"):
		highlight_index = wrapi(highlight_index-1, 0, cards.size())
		update_highlight()
	if event.is_action_pressed("change_highlight_right"):
		highlight_index = wrapi(highlight_index+1, 0, cards.size())
		update_highlight()
	return

func update_hand():
	for child in get_children():
		remove_child(child)

	@warning_ignore("integer_division")
	var start_position:int = -(spacing*(cards.size()-1))/2
	var start_angle:float = -(angle_spacing*(cards.size()-1))/2
	for i in cards.size():
		add_child(cards[i])
		if !cards[i].is_face_up: cards[i].flip()
		var tween:Tween = create_tween()
		tween.tween_property(cards[i], "position", Vector2(start_position + (spacing * i), position.y),.2)
		tween.tween_property(cards[i], "rotation", start_angle + (angle_spacing*i),.2)
	return

func add_card(card:Card):
	cards.append(card)
	card.used.connect(_on_card_used)
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

func update_highlight():
	for card:Card in cards:
		card.dehighlight()
	cards[highlight_index].highlight()
	return

func _on_card_used(card:Card):
	remove_card(card)
	card_played.emit(card)
	return
