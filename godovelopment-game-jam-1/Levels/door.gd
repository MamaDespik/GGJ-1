extends Node2D
class_name Door

@export_enum("NORTH", "SOUTH", "EAST", "WEST") var direction
@export var locked:bool

var moving:bool = false

@onready var locked_sprite: Sprite2D = $LockedSprite
@onready var unlocked_sprite: Sprite2D = $UnlockedSprite
@onready var player_detector: Area2D = $PlayerDetector
@onready var closed_door: StaticBody2D = $ClosedDoor
@onready var lock_sfx: AudioStreamPlayer2D = $LockSFX
@onready var unlock_sfx: AudioStreamPlayer2D = $UnlockSFX

signal entered(direction)

func _ready():
	if locked: lock(false)
	else: unlock(false)
	return

func lock(play_sound:bool):
	locked = true
	locked_sprite.show()
	unlocked_sprite.hide()
	closed_door.process_mode = Node.PROCESS_MODE_INHERIT
	if play_sound: lock_sfx.play()
	return

func unlock(play_sound:bool):
	locked = false
	locked_sprite.hide()
	unlocked_sprite.show()
	closed_door.process_mode = Node.PROCESS_MODE_DISABLED
	if play_sound and is_inside_tree(): unlock_sfx.play()
	return

func _on_player_detector_body_entered(_body: Node2D) -> void:
	if !locked and !moving:
		entered.emit(direction)
	return

func _on_player_detector_body_exited(_body: Node2D) -> void:
	if locked and !moving:
		lock(true)
	return
