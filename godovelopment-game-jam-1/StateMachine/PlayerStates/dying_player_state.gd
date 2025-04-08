extends State
class_name DyingPlayerState

var player_parent:Player

func enter():
	player_parent = parent
	print("Player Died")
	#TODO
	return
