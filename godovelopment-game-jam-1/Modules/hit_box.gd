extends Node2D
class_name HitBox

@export_enum("Enemy", "Player") var hitbox_type:String
@export var damage:int = 0

@export var enabled:bool:
	set(value):
		enabled = value
		if collision_shape_2d:
			collision_shape_2d.disabled = !value

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

func _ready() -> void:
	match hitbox_type:
		"Enemy":
			area_2d.collision_layer = 64 #an enemy hitbox
		"Player":
			area_2d.collision_layer = 32 #a player hitbox
	enabled = enabled
	return
