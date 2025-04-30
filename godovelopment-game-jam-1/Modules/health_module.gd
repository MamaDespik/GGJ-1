extends HBoxContainer
class_name HealthModule

@export var max_health:int = 3

var current_health:int

@onready var full_heart: TextureRect = %FullHeart
@onready var empty_heart: TextureRect = %EmptyHeart
@onready var health_display: Container = $HealthDisplay

signal took_damage

func _ready() -> void:
	current_health = max_health
	adjust_health(0)
	return

func adjust_health(adjustment:int):
	current_health = clamp(current_health + adjustment, 0, max_health)

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

func take_damage(damage:int):
	adjust_health(-damage)
	if damage > 0: took_damage.emit()
	return

func heal(amount:int):
	adjust_health(amount)
	return

func rotate():
	var vbox:=VBoxContainer.new()
	health_display.replace_by(vbox)
	health_display.queue_free()
	health_display = vbox
	return
