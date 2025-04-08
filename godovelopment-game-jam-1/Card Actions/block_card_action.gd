extends CardAction

func _on_area_2d_area_entered(area: Area2D) -> void:
	var hit_box:HitBox = area.get_parent()
	hit_box.set_deferred("enabled", false)
	return
