extends Node2D
class_name Drop

@export var drop_name:String
@export_multiline var drop_description:String
@export var is_relic:bool = false
@export var magnet_enabled:bool = true
@export var sfx_stream:AudioStream

var should_scatter:bool = true
var target:Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Sprite2D/Area2D
@onready var pickup_sfx: AudioStreamPlayer2D = $PickupSFX

func _ready() -> void:
	if should_scatter: scatter()
	start_animate()
	return

func _physics_process(delta):
	if target != null:
		var distance:float = global_position.distance_to(target.global_position)
		global_position = global_position.move_toward(target.global_position, (200-distance)*delta)
		pass
	return

func scatter():
	var distance := Vector2(randi_range(-100, 100), randi_range(-100, 100))
	var start_position:Vector2 = position
	var tween:Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", start_position + distance, 1)
	tween.tween_property(area_2d, "monitoring", true, .25)
	return

func start_animate():
	var tween:Tween = create_tween()
	tween.tween_interval(randf())
	tween.set_loops()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite_2d, "position", Vector2(0, -5), 1.5)
	tween.tween_property(sprite_2d, "position", Vector2(0, 5), 1.5)

	var original_scale:Vector2 = sprite_2d.scale
	var tween2:Tween = create_tween()
	tween.tween_interval(randf())
	tween2.set_loops()
	tween2.set_ease(Tween.EASE_IN_OUT)
	tween2.set_trans(Tween.TRANS_SINE)
	tween2.tween_property(sprite_2d, "scale", original_scale*1.1, .7)
	tween2.tween_property(sprite_2d, "scale", original_scale*.9, .7)
	return

func do_effect(_player:Player):
	#to be overwritten by implementing classes
	return

func use(player:Player):
	pickup_sfx.stream = sfx_stream
	pickup_sfx.play()
	hide()
	do_effect(player)
	return

func _on_area_2d_body_entered(body: Node2D) -> void:
	use(body)
	return


func _on_pickup_sfx_finished() -> void:
	queue_free()
	return

func _on_magnet_zone_body_entered(body):
	if magnet_enabled:
		target = body
	return

func _on_magnet_zone_body_exited(body):
	if body == target:
		target = null
	return
