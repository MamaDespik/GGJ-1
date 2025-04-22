extends Node2D
class_name CardAction

var player:Player
var card:Card
var original_rotation:float = -999
var original_scale:Vector2

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var placeholder: Sprite2D = $Placeholder

func _ready() -> void:
	placeholder.hide()
	animation_player.play("go")
	return

func _physics_process(_delta: float) -> void:
	if original_rotation == -999:
		original_rotation = global_rotation
	if !original_scale:
		original_scale = scale
	global_rotation = original_rotation
	scale = original_scale
	return

func discard_card():
	card.discard()
	return

func combo():
	card.combo()
	return
