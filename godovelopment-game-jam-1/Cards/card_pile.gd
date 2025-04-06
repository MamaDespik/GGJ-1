extends Node2D
class_name CardPile

var cards:Array[Card]
var offset:int = 3
var count:int = 1 #DEBUG

func draw() -> Card:
	var drawn_card:Card = cards.pop_front()
	if !drawn_card: return null
	remove_child(drawn_card)
	update_cards()
	return drawn_card

func update_cards():
	for child in get_children():
		remove_child(child)
	for i in range(cards.size(),0, -1):
		cards[i-1].position = position + ((i-1) * Vector2(offset, offset))
		add_child(cards[i-1])
		cards[i-1].dehighlight()
	return

func add_card(card:Card):
	cards.append(card)
	update_cards()
	return

func add_cards(new_cards:Array[Card]):
	cards.append_array(new_cards)
	update_cards()
	return

func shuffle():
	cards.shuffle()
	update_cards()
	return

func _input(event):
	if event.is_action_pressed("select"): #DEBUG
		var new_card:Card = load("res://Cards/Card.tscn").instantiate()
		new_card.card_title = str(count)
		count += 1
		add_card(new_card)
	if event.is_action_pressed("cancel"):#DEBUG
		var drawn_card:Card = draw()
		if drawn_card: drawn_card.queue_free()
	if event.is_action_pressed("ui_accept"):#DEBUG
		shuffle()
	return
