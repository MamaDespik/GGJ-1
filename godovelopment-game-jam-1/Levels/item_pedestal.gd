extends Node2D
class_name ItemPedestal

@export var cost:int
@export var replaceable:bool = false
@export var item_scene:PackedScene

var item:Drop
var ready_to_buy:bool = false
var player:Player

@onready var purchase_label: Label = $PlayerDetector/PurchaseLabel
@onready var item_container: Node2D = $ItemContainer
@onready var description_label: Label = $PlayerDetector/DescriptionLabel

func _ready() -> void:
	if item_scene: add_item()
	purchase_label.text = str(cost)+"G"
	return

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		if ready_to_buy and is_instance_valid(item):
			if player.gold_count >= cost:
				player.gold_count -= cost
				if item.is_relic:
					player.get_relic(item)
				item.use(player)
				if replaceable: add_item()
				else: purchase_label.hide()
			else:
				#TODO do something to indicate you can't buy
				pass
	return

func add_item():
	item = item_scene.instantiate()
	item.should_scatter = false
	item_container.add_child(item)
	return

func _on_player_detector_body_entered(_body: Node2D) -> void:
	if is_instance_valid(item):
		purchase_label.show()
		description_label.text = item.drop_description
		description_label.show()
	ready_to_buy = true
	return


func _on_player_detector_body_exited(_body: Node2D) -> void:
	purchase_label.hide()
	description_label.hide()
	ready_to_buy = false
	return
