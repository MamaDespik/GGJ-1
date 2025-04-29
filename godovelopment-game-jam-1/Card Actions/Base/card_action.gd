extends Node2D
class_name CardAction

@export var track_shadow:bool = false

var player:Player
var card:Card
var original_rotation:float = -999
var original_scale:Vector2
var hit_box:HitBox
var shadow:Sprite2D
var shadow_follow:Node2D
var shadow_offset:Vector2

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var placeholder: Sprite2D = $Placeholder


func _ready() -> void:
	placeholder.hide()
	shadow = get_node_or_null("%Shadow")
	shadow_follow = get_node_or_null("%Shadow Follow")
	shadow_offset = (shadow_follow.position - shadow.position).rotated(-rotation)

	hit_box = get_node_or_null("%Hitbox")
	if hit_box:
		hit_box.damage += player.bonus_damage
	animation_player.play("go")
	return

func _physics_process(_delta: float) -> void:
	if original_rotation == -999:
		original_rotation = global_rotation
	if !original_scale:
		original_scale = scale
	global_rotation = original_rotation
	scale = original_scale
	try_track_shadow()
	return

func discard_card():
	card.discard()
	player.using_card = false
	return

func combo():
	card.combo()
	return

func stop_player_movement():
	player.movement_disabled += 1
	return

func restore_player_movement():
	player.movement_disabled -= 1
	return

func try_track_shadow():
	if track_shadow:
		shadow.global_position = shadow_follow.global_position - shadow_offset
	return
