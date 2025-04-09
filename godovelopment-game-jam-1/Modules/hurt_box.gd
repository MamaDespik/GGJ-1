extends Node2D
class_name HurtBox

@export_enum("Enemy", "Player") var hurtbox_type:String
@export var enabled:bool:
	set(value):
		enabled = value
		if area_2d:
			area_2d.monitoring = value


@onready var area_2d: Area2D = $Area2D

signal hurt(damage:int)

func _ready() -> void:
	match hurtbox_type:
		"Enemy":
			area_2d.collision_mask = 32 #look for playerhitboxes
		"Player":
			area_2d.collision_mask = 64 #look for enemyhitboxes
	return

func _on_area_2d_area_entered(area: Area2D) -> void:
	hurt.emit(area.get_parent().damage)
	return
