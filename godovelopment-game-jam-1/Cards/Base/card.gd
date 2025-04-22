extends Node2D
class_name Card

@export var card_title:String
@export var card_image:Texture
@export var card_text:String
@export var card_action_scene:PackedScene
@export var combo_card:PackedScene

var is_face_up:bool = true
var is_highlighted:bool = false
var position_tween:Tween
var target_angle:float = 0
var initial_card_height:float
var highlighted_height_adjustment:float = -50
var player:Player
var current_card_action:CardAction
var simulated:bool = false
var is_using:bool = false
var animation_time:float = .4

@onready var card_sprite: Sprite2D = $CardSprite
@onready var card_model: Node3D = %CardModel

signal discarded(card:Card)
signal trashed(card:Card)
signal comboed(first_card:Card, second_card:Card)

func _ready():
	card_model.title_label.text = card_title
	card_model.image_texture.texture = card_image
	card_model.text_label.text = card_text
	initial_card_height = card_sprite.position.y
	return

func _input(event):
	if event.is_action_pressed("select") and !is_using:
		if is_highlighted:
			use()
	if event.is_action_pressed("cancel"):
		if is_highlighted and !simulated:
			discard()
	return

func flip():
	target_angle += PI
	is_face_up = !is_face_up
	var tween = create_tween()
	tween.tween_property(card_model, "rotation:y", target_angle, .3)
	return

func use():
	if simulated:
		discard()
		return
	is_using = true
	current_card_action = card_action_scene.instantiate()
	current_card_action.player = player
	current_card_action.card = self
	current_card_action.scale.y = player.direction
	player.card_actions.add_child(current_card_action)
	return

func discard():
	is_using = false
	dehighlight()
	discarded.emit(self)
	return

func trash():
	is_using = false
	dehighlight()
	trashed.emit(self)
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
	position_tween = create_tween()
	position_tween.set_ease(Tween.EASE_IN_OUT)
	position_tween.set_parallel()
	position_tween.tween_property(self, "global_position", new_position, animation_time)
	position_tween.tween_property(self, "rotation", new_rotation, animation_time)
	return

func combo():
	if combo_card:
		comboed.emit(self, combo_card.instantiate())
	return
