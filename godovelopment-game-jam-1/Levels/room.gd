extends Node2D
class_name Room

@export var exit_north:bool = false
@export var exit_south:bool = false
@export var exit_east:bool = false
@export var exit_west:bool = false
@export var locked:bool = true
@export var enemies:Array[Enemy]

var doors:Array[Door]

@onready var north_wall: Sprite2D = $NorthWall
@onready var north_wall_door: Sprite2D = $NorthWallDoor
@onready var north_door: Door = %NorthDoor
@onready var south_wall: Sprite2D = $SouthWall
@onready var south_wall_door: Sprite2D = $SouthWallDoor
@onready var south_door: Door = %SouthDoor
@onready var east_wall: Sprite2D = $EastWall
@onready var east_wall_door: Sprite2D = $EastWallDoor
@onready var east_door: Door = %EastDoor
@onready var west_wall: Sprite2D = $WestWall
@onready var west_wall_door: Sprite2D = $WestWallDoor
@onready var west_door: Door = %WestDoor

signal player_exited(direction:String)
signal room_cleared

func _ready() -> void:
	set_wall(exit_north, north_wall, north_wall_door, north_door)
	set_wall(exit_south, south_wall, south_wall_door, south_door)
	set_wall(exit_east, east_wall, east_wall_door, east_door)
	set_wall(exit_west, west_wall, west_wall_door, west_door)
	set_doors()
	set_enemies()
	return

func set_doors():
	for door:Door in doors:
		if locked: door.lock()
		else: door.unlock()
	return

func set_wall(has_exit:bool, wall:Node, wall_door:Node, door:Door):
	if has_exit:
		wall.hide()
		wall_door.show()
		doors.append(door)
		door.entered.connect(_on_door_entered)
	else:
		wall.show()
		wall_door.hide()
		door.lock()
	return

func set_enemies():
	for enemy:Enemy in enemies:
		enemy.died.connect(_on_enemy_died)

func _on_door_entered(direction:String):
	print("Player leaving room, going ", direction)
	player_exited.emit(direction)
	return

func _on_enemy_died(enemy:Enemy):
	enemies.erase(enemy)
	enemy.queue_free()
	if enemies.size() <= 0:
		locked = false
		set_doors()
		room_cleared.emit()
	return
