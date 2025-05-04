extends Node2D
class_name CardPile

var cards:Array[Card]
var offset:int = 3

@onready var shuffle_sfx: AudioStreamPlayer2D = $ShuffleSFX

func _ready() -> void:
	for card in get_children():
		if card is Card:
			cards.append(card)
	return

func draw() -> Card:
	var drawn_card:Card = cards.pop_front()
	if drawn_card:
		remove_child(drawn_card)
		update_cards()
	return drawn_card

func update_cards():
	for child in get_children():
		if child is Card:
			remove_child(child)
	for i in range(cards.size(),0, -1):
		add_child(cards[i-1])
		if cards[i-1].is_face_up: cards[i-1].flip()
		cards[i-1].dehighlight()
		cards[i-1].update_position(global_position + ((i-1)*Vector2(offset,offset)))
	return

func add_card(card:Card, put_on_top:bool = false):
	if put_on_top:
		cards.insert(0, card)
	else:
		cards.append(card)
	update_cards()
	return

func add_cards(new_cards:Array[Card]):
	cards.append_array(new_cards)
	update_cards()
	return

func shuffle():
	cards.shuffle()
	shuffle_sfx.play()
	for card:Card in cards:
		card.global_position.x += randi_range(-10,10)
		card.global_position.y += randi_range(-10,10)
		card.rotation += randf_range(-.3,.3)
	update_cards()
	return
