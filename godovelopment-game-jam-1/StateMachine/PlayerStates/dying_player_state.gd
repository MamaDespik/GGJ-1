extends State
class_name DyingPlayerState

var player_parent:Player

func enter():
	player_parent = parent
	player_parent.start_animation("dying")
	player_parent.stop_invincibility()
	player_parent.hurt_box.set_deferred("enabled", false)
	#TODO
	return
