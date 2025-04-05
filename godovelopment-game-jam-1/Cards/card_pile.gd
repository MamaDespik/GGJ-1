extends Node2D
class_name CardPile

var cards:Array[Card]
var offset:int = 3
var count:int = 1 #DEBUG

func draw() -> Card:
	var drawn_card:Card = cards.pop_front()
	remove_child(drawn_card)
	redraw_cards()
	return drawn_card

func redraw_cards():
	for child in get_children():
		remove_child(child)
	for i in range(cards.size(),0, -1):
		cards[i-1].position = position + ((i-1) * Vector2(offset, offset))
		add_child(cards[i-1])
	return

func add_card(card:Card):
	print("add card")
	cards.append(card)
	print(cards.size())
	#add_child(card)
	redraw_cards()
	return

func _input(event):
	if event.is_action_pressed("select"): #DEBUG
		var new_card:Card = load("res://Cards/Card.tscn").instantiate()
		new_card.card_title = str(count)
		count += 1
		add_card(new_card)
		
	if event.is_action_pressed("cancel"):
		draw().queue_free()
	return
