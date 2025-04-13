extends Floor
class_name ShopFloor

func _ready() -> void:
	super()
	start_room.locked = true
	start_room.set_doors()
	start_room.room_cleared.connect(_on_room_cleared)
	return

func _on_room_cleared():
	floor_cleared.emit()
	return
