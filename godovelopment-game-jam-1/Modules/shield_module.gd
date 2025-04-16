extends HBoxContainer
class_name ShieldModule

@export var current_shield:int = 0

@onready var full_shield: ColorRect = %FullShield
@onready var shield_display: Container = $ShieldDisplay

signal no_shield(spillover:int)

func _ready() -> void:
	adjust_shield(0)
	return

func adjust_shield(adjustment:int):
	current_shield += adjustment
	if current_shield < 0:
		no_shield.emit(-current_shield)
		current_shield = 0

	for child in shield_display.get_children():
		shield_display.remove_child(child)
		child.queue_free()

	for i in current_shield:
		var new_shield := full_shield.duplicate()
		new_shield.show()
		shield_display.add_child(new_shield)
	return

func take_damage(damage:int):
	adjust_shield(-damage)
	return

func add_shield(amount:int):
	adjust_shield(amount)
	return

func rotate():
	var vbox:=VBoxContainer.new()
	shield_display.replace_by(vbox)
	shield_display.queue_free()
	shield_display = vbox
	return
