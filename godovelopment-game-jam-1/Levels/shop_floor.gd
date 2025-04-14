extends Floor
class_name ShopFloor

func _ready() -> void:
	super()
	start_room.room_cleared.connect(_on_room_cleared)
	start_room.player = player
	start_room.set_player()
	return

func _on_room_cleared():
	floor_cleared.emit()
	return
