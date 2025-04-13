extends Room
class_name ShopRoom

var ready_to_exit:bool = false

@onready var exit_label: Label = $ShopExit/ExitLabel
@onready var pedestal_container: Node2D = $PedestalContainer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		if ready_to_exit:
			room_cleared.emit()
	return

func set_player(player:Player):
	for item_pedestal:ItemPedestal in pedestal_container.get_children():
		item_pedestal.player = player
	return

func _on_exit_player_detector_body_entered(_body: Node2D) -> void:
	ready_to_exit = true
	exit_label.show()
	return

func _on_exit_player_detector_body_exited(_body: Node2D) -> void:
	ready_to_exit = false
	exit_label.hide()
	return
