extends State
class_name DyingPlayerState

var player_parent:Player

func enter():
	player_parent = parent
	print("Player Died")
	player_parent.stop_invincibility()
	player_parent.hurt_box.set_deferred("enabled", false)
	#TODO
	return
