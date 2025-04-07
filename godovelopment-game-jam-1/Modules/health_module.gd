extends Node2D
class_name HealthModule

@export var max_health:int = 3

var current_health:int = max_health

@onready var full_heart: ColorRect = %FullHeart
@onready var empty_heart: ColorRect = %EmptyHeart
@onready var health_display: HBoxContainer = $HealthDisplay

signal died

func _ready() -> void:
	adjust_health(0)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select"): #DEBUG
		adjust_health(1)
	if event.is_action_pressed("cancel"): #DEBUG
		adjust_health(-1)
	return

func adjust_health(adjustment:int):
	current_health = clamp(current_health + adjustment, 0, max_health)
	if current_health == 0: died.emit()

	for child in health_display.get_children():
		health_display.remove_child(child)
		child.queue_free()

	for i in current_health:
		var new_heart := full_heart.duplicate()
		new_heart.show()
		health_display.add_child(new_heart)
	for i in max_health-current_health:
		var new_heart := empty_heart.duplicate()
		new_heart.show()
		health_display.add_child(new_heart)
	return
