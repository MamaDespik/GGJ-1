extends Node2D
class_name Drop

@export var sfx_stream:AudioStream

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Sprite2D/Area2D
@onready var pickup_sfx: AudioStreamPlayer2D = $PickupSFX

func _ready() -> void:
	scatter()
	start_animate()
	return

func scatter():
	var distance := Vector2(randi_range(-100, 100), randi_range(-100, 100))
	var start_position:Vector2 = position
	var tween:Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", start_position + distance, 1)
	tween.tween_property(area_2d, "monitoring", true, 1)
	return

func start_animate():
	var tween:Tween = create_tween()
	tween.set_loops()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite_2d, "position", Vector2(0, -5), 1.5)
	tween.tween_property(sprite_2d, "position", Vector2(0, 5), 1.5)

	var tween2:Tween = create_tween()
	tween2.set_loops()
	tween2.set_ease(Tween.EASE_IN_OUT)
	tween2.set_trans(Tween.TRANS_SINE)
	tween2.tween_property(sprite_2d, "scale", Vector2(.26,.26), .7)
	tween2.tween_property(sprite_2d, "scale", Vector2(.24,.24), .7)
	return

func do_effect(_player:Player):
	#to be overwritten by implementing classes
	return

func _on_area_2d_body_entered(body: Node2D) -> void:
	pickup_sfx.stream = sfx_stream
	pickup_sfx.play()
	hide()
	do_effect(body)
	return


func _on_pickup_sfx_finished() -> void:
	queue_free()
	return
