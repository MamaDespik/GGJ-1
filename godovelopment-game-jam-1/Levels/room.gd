extends Node2D
class_name Room

@export var exit_north:bool = false
@export var exit_south:bool = false
@export var exit_east:bool = false
@export var exit_west:bool = false
@export var locked:bool = true
@export var enemies:Array[Enemy]
@export var destructables:Array[Enemy]

var doors:Array[Door]
var moving:bool = false
var player:Player

@onready var north_door: Door = %NorthDoor
@onready var north_middle: Sprite2D = %NorthMiddle
@onready var south_door: Door = %SouthDoor
@onready var south_middle: Sprite2D = %SouthMiddle
@onready var east_door: Door = %EastDoor
@onready var east_middle: Sprite2D = %EastMiddle
@onready var west_door: Door = %WestDoor
@onready var west_middle: Sprite2D = %WestMiddle
@onready var enemies_container: Node2D = $EnemiesContainer
@onready var destructable_container: Node2D = $DestructableContainer

signal player_exited(room:Room, direction)
signal room_cleared

func _ready() -> void:
	set_wall(exit_north,north_door, north_middle)
	set_wall(exit_south, south_door, south_middle)
	set_wall(exit_east, east_door, east_middle)
	set_wall(exit_west, west_door, west_middle)
	set_doors(false)
	init_enemies()
	init_destructables()
	return

func set_doors(override:bool = true):
	for door:Door in doors:
		door.moving = moving
		if locked and override: door.lock(override)
		else: door.unlock(override)
	return

func set_wall(has_exit:bool, door:Door, middle:Sprite2D):
	if has_exit:
		door.show()
		middle.hide()
		doors.append(door)
		door.entered.connect(_on_door_entered)
	else:
		door.hide()
		middle.show()
		door.lock(false)
	return

func init_enemies():
	for enemy:Enemy in enemies:
		enemy.player = player
		enemy.paused = true
		enemies_container.add_child(enemy)
		enemy.position = Vector2(randi_range(500, 1500), randi_range(300, 700))
		enemy.died.connect(_on_enemy_died)
	return

func set_enemy_pause():
	for enemy:Enemy in enemies:
		enemy.paused = moving
	return

func init_destructables():
	for dest:Enemy in destructables:
		dest.player = player
		destructable_container.add_child(dest)
		dest.position = Vector2(randi_range(500, 1500), randi_range(300, 700))
		dest.died.connect(_on_destructable_died)

func start_move():
	moving = true
	for door:Door in doors:
		door.moving = moving
	set_enemy_pause()
	return

func end_move():
	moving = false
	set_doors()
	set_enemy_pause()
	return

func _on_door_entered(direction):
	player_exited.emit(self, direction)
	return

func _on_enemy_died(enemy:Enemy):
	enemies.erase(enemy)
	enemy.drop_module.drop(self, enemy.position)
	if enemies.size() <= 0:
		locked = false
		set_doors()
		room_cleared.emit()
	return

func _on_destructable_died(destructable:Enemy):
	destructable.drop_module.drop(self, destructable.position)
	return
