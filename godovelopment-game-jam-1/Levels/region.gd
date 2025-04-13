extends Node
class_name Region

@export var floor_lengths:Array[int]
@export var floor_scene:PackedScene
@export var shop_scene:PackedScene


func get_floor() -> Floor:
	var new_floor:Floor = floor_scene.instantiate()
	new_floor.critical_length = floor_lengths.pop_front()
	return new_floor

func get_shop() -> Floor:
	return shop_scene.instantiate()
