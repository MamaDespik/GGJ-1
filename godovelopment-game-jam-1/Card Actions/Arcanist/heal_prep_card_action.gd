extends CardAction

var has_hit:bool = false

@onready var outgoing_attack_sprite: Sprite2D = $OutgoingAttackSprite
@onready var incoming_attack_sprite: Sprite2D = $IncomingAttackSprite

func trigger_combo():
	if !has_hit:
		has_hit = true
		incoming_attack_sprite.position = outgoing_attack_sprite.position
		incoming_attack_sprite.position.x += 64
		var tween:Tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_QUAD)
		tween.tween_property(incoming_attack_sprite, "position", Vector2(0,0), 1.5)
		animation_player.play("come")
		combo()
	return

func _on_enemy_detector_area_entered(_area: Area2D) -> void:
	trigger_combo()
	return

func _on_enemy_detector_body_entered(_body: Node2D) -> void:
	trigger_combo()
	return
