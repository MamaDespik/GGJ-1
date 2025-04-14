extends Room
class_name ShopRoom

@export var relic_scenes:Array[PackedScene]
@export var discard_cost:int = 5

var ready_to_exit:bool = false
var ready_to_discard:bool = false
var discarding:bool = false
var deck:CardPile

@onready var exit_label: Label = $ShopExit/ExitLabel
@onready var discard_label: Label = $CardDiscardZone/DiscardLabel
@onready var pedestal_container: Node2D = $PedestalContainer
@onready var relic_1_pedistal: ItemPedestal = $PedestalContainer/Relic1Pedistal
@onready var relic_2_pedistal: ItemPedestal = $PedestalContainer/Relic2Pedistal
@onready var hand: Hand = $CardDiscardZone/Hand

func _ready() -> void:
	relic_1_pedistal.item_scene = relic_scenes.pick_random()
	relic_1_pedistal.add_item()
	relic_2_pedistal.item_scene = relic_scenes.pick_random()
	relic_2_pedistal.add_item()
	hand.card_removed.connect(_on_hand_card_removed)
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
		if discarding:
			if player.gold_count < discard_cost:
				get_viewport().set_input_as_handled()
				print("Can't afford discard.")
			else:
				player.gold_count -= discard_cost
				print("Charged for discard.")
		elif ready_to_discard:
			start_discard()
	return

func set_player():
	for item_pedestal:ItemPedestal in pedestal_container.get_children():
		item_pedestal.player = player
	return

func start_discard():
	discarding = true
	#TODO display prompt to discard for cost
	for i in deck.cards.size():
		var card:Card = deck.draw()
		card.simulated = true
		hand.add_card(card)
	return

func stop_discard():
	discarding = false
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

func _on_discard_player_detector_body_entered(_body: Node2D) -> void:
	ready_to_discard = true
	discard_label.show()
	return

func _on_discard_player_detector_body_exited(_body: Node2D) -> void:
	ready_to_discard = false
	discard_label.hide()
	stop_discard()
	return

func _on_hand_card_removed(card:Card):
	if discarding:
		card.queue_free()
	else:

		deck.add_card(card)
	return
