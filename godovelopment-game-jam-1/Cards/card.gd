extends Node2D
class_name Card

@export var card_title:String
@export var card_image:Texture
@export var card_text:String

var is_face_up:bool = true

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
		flip()
	return

func flip():
	var target_angle:float
	if is_face_up: target_angle = PI
	else: target_angle = 0
	var tween = create_tween()
	tween.tween_property(card_model, "rotation", Vector3(0,target_angle,0), .1)
	tween.tween_property(self, "is_face_up", !is_face_up, 0)
	return
	
func use():
	used.emit(self)
	return
