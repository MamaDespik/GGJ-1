extends Node2D
class_name Hand

var hand_size:int = 3
var spacing:int = 200
var angle_spacing:float = PI/40
var cards:Array[Card]
var highlight_index:int = 0

signal card_removed(card:Card)
signal empty

func _ready() -> void:
	return

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("change_highlight_left"):
		highlight_index = wrapi(highlight_index-1, 0, cards.size())
		update_highlight()
	if event.is_action_pressed("change_highlight_right"):
		highlight_index = wrapi(highlight_index+1, 0, cards.size())
		update_highlight()
	return

func update_hand():
	update_highlight()
	for child in get_children():
		remove_child(child)
	@warning_ignore("integer_division")
	var start_position:float = global_position.x -(spacing*(cards.size()-1))/2
	var start_angle:float = -(angle_spacing*(cards.size()-1))/2
	for i in cards.size():
		add_child(cards[i])
		if !cards[i].is_face_up:
			cards[i].flip()
		cards[i].update_position(Vector2(start_position + (spacing * i), global_position.y),
								 start_angle    + (angle_spacing * i))
	return

func add_card(card:Card):
	cards.append(card)
	card.discarded.connect(_on_card_removed)
	update_hand()
	return

func remove_card(card:Card):
	if cards.has(card):
		cards.erase(card)
		card.discarded.disconnect(_on_card_removed)
	if get_children().has(card):
		remove_child(card)
	card_removed.emit(card)
	update_hand()
	return

func update_highlight():
	for card:Card in cards:
		card.dehighlight()
	if cards.size()>0:
		highlight_index = clampi(highlight_index, 0, cards.size()-1)
		cards[highlight_index].highlight()
	return

func check_empty():
	if cards.size() < 1:
		empty.emit()
	return

func _on_card_removed(card:Card):
	remove_card(card)
	return
