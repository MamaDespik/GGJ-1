extends Node2D
class_name HitBox

@export_enum("Enemy", "Player") var hitbox_type:String
@export var damage:int = 0

@export var enabled:bool:
	set(value):
		enabled = value
		if area_2d:
			area_2d.monitorable = value
		id = randi()

var id:int

@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	match hitbox_type:
		"Enemy":
			area_2d.collision_layer = 64 #an enemy hitbox
		"Player":
			area_2d.collision_layer = 32 #a player hitbox
	enabled = enabled
	return
