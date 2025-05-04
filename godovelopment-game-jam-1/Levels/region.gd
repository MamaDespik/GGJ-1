extends Node
class_name Region

@export var floor_lengths:Array[int]
@export var floor_scene:PackedScene
@export var shop_floor_scene:PackedScene
@export var boss_floor_scene:PackedScene

func get_floor() -> Floor:
	var new_floor:Floor
	if floor_lengths.size() > 1:
		new_floor = floor_scene.instantiate()
	if floor_lengths.size() == 1:
		new_floor = boss_floor_scene.instantiate()
	new_floor.critical_length = floor_lengths.pop_front()
	return new_floor

func get_shop() -> Floor:
	return shop_floor_scene.instantiate()
