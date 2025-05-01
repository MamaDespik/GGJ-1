extends CardAction

func _ready() -> void:
	super()
	original_rotation = 0
	original_scale = Vector2(1,1)
	return

func start_blocking_player():
	stop_player_movement()
	player.damage_negation += 1
	return

func stop_blocking_player():
	restore_player_movement()
	player.damage_negation -= 1
	return

func counter_attack(target_position:Vector2):
	player.target_position = target_position
	animation_player.play("stop")
	return

func _on_attack_detector_area_entered(area: Area2D) -> void:
	counter_attack(area.global_position)
	return

func _on_attack_detector_body_entered(body: Node2D) -> void:
	counter_attack(body.global_position)
	return
