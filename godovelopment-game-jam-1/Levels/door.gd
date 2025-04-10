extends Node2D
class_name Door

@export_enum("NORTH", "SOUTH", "EAST", "WEST") var direction
@export var locked:bool

@onready var locked_sprite: Sprite2D = $LockedSprite
@onready var unlocked_sprite: Sprite2D = $UnlockedSprite
@onready var player_detector: Area2D = $PlayerDetector
@onready var closed_door: StaticBody2D = $ClosedDoor

signal entered(direction)

func _ready():
	if locked: lock()
	else: unlock()
	return

func lock():
	locked = true
	locked_sprite.show()
	unlocked_sprite.hide()
	closed_door.process_mode = Node.PROCESS_MODE_INHERIT
	return

func unlock():
	locked = false
	locked_sprite.hide()
	unlocked_sprite.show()
	closed_door.process_mode = Node.PROCESS_MODE_DISABLED
	return

func _on_player_detector_body_entered(_body: Node2D) -> void:
	if !locked:
		entered.emit(direction)
	return

func _on_player_detector_body_exited(_body: Node2D) -> void:
	if locked:
		lock()
	return
