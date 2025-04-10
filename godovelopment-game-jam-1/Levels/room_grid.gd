extends Node
class_name RoomGrid

var rooms:Dictionary[Vector2i,Room]

func add_initial_room(room:Room):
	var location := Vector2i(0,0)
	rooms[location] = room
	return

#add the given room in the direction of the existing room
func add_room(new_room:Room, direction:int, existing_room:Room):
	var location:Vector2i = rooms.find_key(existing_room)
	match direction:
		Globals.NORTH:
			location.y -= 1
		Globals.SOUTH:
			location.y += 1
		Globals.EAST:
			location.x += 1
		Globals.WEST:
			location.x -= 1
	rooms[location] = new_room
	return

func get_adjacent(room:Room) -> Array[Room]:
	var location:Vector2i = rooms.find_key(room)
	return _get_adjacent_coords(location.x, location.y)

func _get_adjacent_coords(x:int, y:int) -> Array[Room]:
	var north_room:Room = _get_room(x,y-1)
	var south_room:Room = _get_room(x,y+1)
	var east_room:Room = _get_room(x+1,y)
	var west_room:Room = _get_room(x-1,y)
	var adjacent_rooms:Array[Room] = [north_room, south_room, east_room, west_room]
	return adjacent_rooms

func _get_room(x:int, y:int) -> Room:
	var location:= Vector2i(x,y)
	if !rooms.has(location):
		return null
	return rooms[location]

func update_exits():
	for room:Room in rooms.values():
		var adjacent_rooms:Array[Room] = get_adjacent(room)
		if adjacent_rooms[Globals.NORTH]: room.exit_north = true
		else: room.exit_north = false
		if adjacent_rooms[Globals.SOUTH]: room.exit_south = true
		else: room.exit_south = false
		if adjacent_rooms[Globals.EAST]: room.exit_east = true
		else: room.exit_east = false
		if adjacent_rooms[Globals.WEST]: room.exit_west = true
		else: room.exit_west = false
	return
