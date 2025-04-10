extends Node2D


@export var critical_length:int
@export var branching_probability:float
@export var room_scene:PackedScene
@export var player: Player
@export var enemy_scenes:Array[PackedScene]
@export var boss_scenes:Array[PackedScene]

var start_room:Room
var boss_room:Room
var moving_rooms:bool = false

@onready var room_grid: RoomGrid = $RoomGrid
@onready var active_rooms: Node2D = $ActiveRooms

func _ready() -> void:
	start_room = room_scene.instantiate()
	room_grid.add_initial_room(start_room)
	start_room.locked = false
	start_room.player_exited.connect(_on_room_player_exited)
	var current_room:Room = start_room
	for i in critical_length:
		var new_room:Room = add_new_room(current_room)
		give_enemies(new_room)
		current_room = new_room

	boss_room = add_new_room(current_room)
	give_boss(boss_room)
	boss_room.room_cleared.connect(_on_boss_room_cleared)

	room_grid.update_exits()
	active_rooms.add_child(start_room)
	return

func add_new_room(current_room:Room) -> Room:
	var empty_adjacent_indexes:Array[int] = room_grid.get_empty_neighbors(current_room)
	var new_room:Room = room_scene.instantiate()
	room_grid.add_room(new_room, empty_adjacent_indexes.pick_random(), current_room)
	new_room.locked = true
	new_room.player_exited.connect(_on_room_player_exited)
	return new_room

func give_enemies(room:Room):
	room.enemies.append(enemy_scenes.pick_random().instantiate())
	if randf() < .5:
		give_enemies(room)
	return

func give_boss(room:Room):
	room.enemies.append(boss_scenes.pick_random().instantiate())
	return

func _on_room_player_exited(room:Room, direction):
	if moving_rooms: return
	moving_rooms = true
	var new_room:Room = room_grid.get_adjacent(room)[direction]
	new_room.player = player
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

func _on_boss_room_cleared():
	print("Floor cleared!")
	#TODO
	return
