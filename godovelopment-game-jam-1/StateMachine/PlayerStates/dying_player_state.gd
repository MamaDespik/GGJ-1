extends State
class_name DyingPlayerState

var player_parent:Player

func enter():
	player_parent = parent
	player_parent.start_animation("dying")
	player_parent.sprite_2d.material.set_shader_parameter("active", false)
	player_parent.damage_negation += 10
	player_parent.hurt_box.enabled = false
	player_parent.died.emit()
	return

func process_frame(_delta):
	player_parent.damage_negation += 1
	return
