extends Node2D
class_name Card

@export var card_title:String
@export var card_image:Texture
@export var card_text:String
@export var card_action_scene:PackedScene

var is_face_up:bool = true
var is_highlighted:bool = false
var position_tween:Tween
var target_angle:float = 0
var initial_card_height:float
var highlighted_height_adjustment:float = -100
var player:Player
var current_card_action:CardAction
var simulated:bool = false

@onready var card_sprite: Sprite2D = $CardSprite
@onready var card_model = $CardSprite/CardModelViewport/CardModel
@onready var card_front = %CardFront

signal used(card_action:CardAction)
signal discarded(card:Card)

func _ready():
	card_front.title_label.text = card_title
	card_front.image_texture.texture = card_image
	card_front.text_label.text = card_text
	initial_card_height = card_sprite.position.y
	return

func _input(event):
	#if event.is_action_pressed("ui_accept"): #DEBUG
		#if is_highlighted: flip()
	if event.is_action_pressed("select"):
		if is_highlighted:
			use()
			discard()
	if event.is_action_pressed("cancel"):
		if is_highlighted:
			discard()
	return

func flip():
	target_angle += PI
	is_face_up = !is_face_up
	var tween = create_tween()
	tween.tween_property(card_model, "rotation:y", target_angle, .3)
	return

func use():
	if simulated:return
	current_card_action = card_action_scene.instantiate()
	used.emit(current_card_action)
	return

func discard():
	dehighlight()
	discarded.emit(self)
	return

func highlight():
	is_highlighted = true
	z_index = 99
	var tween:Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "scale", Vector2(1.1,1.1), .1)
	tween.tween_property(card_sprite, "position:y", initial_card_height + highlighted_height_adjustment, .1)
	return

func dehighlight():
	is_highlighted = false
	z_index = 0
	var tween:Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "scale", Vector2(1,1), .1)
	tween.tween_property(card_sprite, "position:y", initial_card_height, .1)
	return

func update_position(new_position:Vector2, new_rotation:float = 0):
	var animation_time:float = .4
	position_tween = create_tween()
	position_tween.set_ease(Tween.EASE_IN_OUT)
	position_tween.set_parallel()
	position_tween.tween_property(self, "global_position", new_position, animation_time)
	position_tween.tween_property(self, "rotation", new_rotation, animation_time)
	return
