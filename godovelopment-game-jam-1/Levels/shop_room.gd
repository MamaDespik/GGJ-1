extends Room
class_name ShopRoom

@export var relic_scenes:Array[PackedScene]
@export var removal_cost:int = 5

var ready_to_exit:bool = false
var ready_to_remove:bool = false
var removing:bool = false
var deck:CardPile

@onready var exit_label: Label = $ShopExit/ExitLabel
@onready var remove_card_label: Label = $CardRemovalZone/RemoveCardLabel
@onready var remove_card_label_2: Label = $CardRemovalZone/RemoveCardLabel2
@onready var pedestal_container: Node2D = $PedestalContainer
@onready var relic_1_pedistal: ItemPedestal = $PedestalContainer/Relic1Pedistal
@onready var relic_2_pedistal: ItemPedestal = $PedestalContainer/Relic2Pedistal
@onready var hand: Hand = $CardRemovalZone/Hand

func _ready() -> void:
	relic_1_pedistal.item_scene = relic_scenes.pick_random()
	relic_1_pedistal.add_item()
	relic_2_pedistal.item_scene = relic_scenes.pick_random()
	relic_2_pedistal.add_item()
	remove_card_label_2.text += str(removal_cost) + "G"
	hand.card_removed.connect(_on_hand_card_removed)
	hand.spacing = 50
	exit_north = false
	exit_south = false
	exit_east = false
	exit_west = false
	locked = true
	super()
	return

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		if ready_to_exit:
			room_cleared.emit()
		if ready_to_remove:
			start_card_removal()
	return

func set_player():
	for item_pedestal:ItemPedestal in pedestal_container.get_children():
		item_pedestal.player = player
	return

func start_card_removal():
	removing = true
	remove_card_label_2.show()
	for i in deck.cards.size():
		var card:Card = deck.draw()
		card.simulated = true
		hand.add_card(card)
	return

func stop_card_removal():
	removing = false
	remove_card_label_2.hide()
	var cards_to_remove:Array[Card]
	for unpicked_card:Card in hand.cards:
		unpicked_card.simulated = false
		cards_to_remove.append(unpicked_card)
	for card_to_remove:Card in cards_to_remove:
		hand.remove_card(card_to_remove)
	return

func _on_exit_player_detector_body_entered(_body: Node2D) -> void:
	ready_to_exit = true
	exit_label.show()
	return

func _on_exit_player_detector_body_exited(_body: Node2D) -> void:
	ready_to_exit = false
	exit_label.hide()
	return

func _on_removal_player_detector_body_entered(_body: Node2D) -> void:
	ready_to_remove = true
	remove_card_label.show()
	return

func _on_removal_player_detector_body_exited(_body: Node2D) -> void:
	ready_to_remove = false
	remove_card_label.hide()
	stop_card_removal()
	return

func _on_hand_card_removed(card:Card):
	if removing:
		if player.gold_count >= removal_cost:
			player.gold_count -= removal_cost
			card.queue_free()
		else:
			hand.add_card(card)
	else:
		deck.add_card(card)
	return
