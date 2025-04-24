extends CardAction

func _process(_delta: float) -> void:
	global_rotation = 0
	return

func start_blocking_player():
	player.movement_disabled += 1
	player.damage_negation += 1
	return

func stop_blocking_player():
	player.movement_disabled -= 1
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
