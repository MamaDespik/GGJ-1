extends Node2D


@export var critical_length:int
@export var branching_probability:float
@export var room_scene:PackedScene

var room_grid:RoomGrid = preload("res://Levels/room_grid.tscn").instantiate()
var rooms:Array[Room]

@onready var active_rooms: Node2D = $ActiveRooms

func _ready() -> void:
	var current_room:Room = room_scene.instantiate()
	room_grid.add_initial_room(current_room)
	rooms.append(current_room)
	for i in critical_length:
		var adjacent_rooms:Array[Room] = room_grid.get_adjacent(current_room)
		var empty_adjacent_indexes:Array[int]
		for j in adjacent_rooms.size():
			if adjacent_rooms[j] == null: empty_adjacent_indexes.append(j)
		var new_room:Room = room_scene.instantiate()
		room_grid.add_room(new_room, empty_adjacent_indexes.pick_random(), current_room)
		rooms.append(current_room)
		current_room = new_room
	room_grid.update_exits()
	active_rooms.add_child(rooms[0])
	return
