extends Node2D
class_name Card

@export var card_title:String
@export var card_image:Texture
@export var card_text:String

var is_face_up:bool = true
var is_highlighted:bool = false

@onready var card_model = $CardSprite/CardModelViewport/CardModel
@onready var card_front = %CardFront

signal used(card:Card)

func _ready():
	card_front.title_label.text = card_title
	card_front.image_texture.texture = card_image
	card_front.text_label.text = card_text
	return

func _input(event):
	if event.is_action_pressed("ui_accept"): #DEBUG
		if is_highlighted: flip()
	if event.is_action_pressed("select"):
		if is_highlighted:
			use()
	return

func flip():
	var target_angle:float
	if is_face_up: target_angle = PI
	else: target_angle = 0
	var tween = create_tween()
	tween.tween_property(card_model, "rotation", Vector3(0,target_angle,0), .3)
	tween.tween_property(self, "is_face_up", !is_face_up, 0)
	return

func use():
	dehighlight()
	used.emit(self)
	return

func highlight():
	is_highlighted = true
	z_index = 99
	var tween:Tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.2,1.2), .2)
	#TODO
	return

func dehighlight():
	is_highlighted = false
	z_index = 0
	var tween:Tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1,1), .2)
	#TODO
	return
