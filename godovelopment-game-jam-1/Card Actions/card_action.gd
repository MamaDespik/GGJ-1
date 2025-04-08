extends Node2D
class_name CardAction

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var placeholder: Sprite2D = $Placeholder


func _ready() -> void:
	placeholder.hide()
	animation_player.play("go")
	return
