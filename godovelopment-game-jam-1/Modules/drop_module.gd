extends Node2D
class_name DropModule

@export var gold_percent:float = .6
@export var heart_percent:float = .2
@export var shield_percent:float = .05

var gold_scene:PackedScene = preload("res://Drops/gold_drop.tscn")
var heart_scene:PackedScene = preload("res://Drops/heart_drop.tscn")
var shield_scene:PackedScene = preload("res://Drops/shield_drop.tscn")

func drop(parent:Node2D, location:Vector2):
	var drops:Array[Drop]
	var repeat:bool = true
	while(repeat):
		if randf() < shield_percent:
			drops.append(shield_scene.instantiate())
		else: repeat = false
	repeat = true
	while(repeat):
		if randf() < heart_percent:
			drops.append(heart_scene.instantiate())
		else: repeat = false
	repeat = true
	while(repeat):
		if randf() < gold_percent:
			drops.append(gold_scene.instantiate())
		else: repeat = false

	for dropped_item:Drop in drops:
		dropped_item.position = location
		parent.add_child(dropped_item)
	return
