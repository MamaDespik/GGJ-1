extends Node2D


@export var critical_length:int
@export var branching_probability:float
@export var room_scene:PackedScene

var room_grid:RoomGrid = preload("res://Levels/room_grid.tscn").instantiate()
var rooms:Array[Room]
var moving_rooms:bool = false

@onready var active_rooms: Node2D = $ActiveRooms
@onready var player: Player = $Player

func _ready() -> void:
	var current_room:Room = room_scene.instantiate()
	room_grid.add_initial_room(current_room)
	rooms.append(current_room)
	current_room.player_exited.connect(_on_room_player_exited)
	for i in critical_length:
		var adjacent_rooms:Array[Room] = room_grid.get_adjacent(current_room)
		var empty_adjacent_indexes:Array[int]
		for j in adjacent_rooms.size():
			if adjacent_rooms[j] == null: empty_adjacent_indexes.append(j)
		var new_room:Room = room_scene.instantiate()
		room_grid.add_room(new_room, empty_adjacent_indexes.pick_random(), current_room)
		rooms.append(new_room)
		new_room.player_exited.connect(_on_room_player_exited)
		current_room = new_room
	room_grid.update_exits()
	active_rooms.add_child(rooms[0])
	return

func _on_room_player_exited(room:Room, direction):
	if moving_rooms: return
	moving_rooms = true
	var new_room:Room = room_grid.get_adjacent(room)[direction]
	var adjustment:Vector2
	match direction:
		Globals.NORTH: adjustment = Vector2(0, -1)
		Globals.SOUTH: adjustment = Vector2(0, 1)
		Globals.EAST: adjustment = Vector2(1, 0)
		Globals.WEST: adjustment = Vector2(-1, 0)
	var travel:Vector2 = Vector2(1920, 1080) * adjustment
	var player_travel:Vector2 = travel - (Vector2(100, 100) * adjustment)
	new_room.position = travel
	active_rooms.call_deferred("add_child",new_room)
	room.start_move()
	new_room.start_move()

	var tween:Tween = create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(player, "position", player.position - player_travel, 1)
	tween.tween_property(room, "position", room.position - travel, 1)
	tween.tween_property(new_room, "position", new_room.position - travel, 1)
	tween.set_parallel(false)
	tween.tween_callback(active_rooms.remove_child.bind(room))
	tween.tween_property(self, "moving_rooms", false, 0)
	tween.tween_callback(room.end_move)
	tween.tween_callback(new_room.end_move)
	return
