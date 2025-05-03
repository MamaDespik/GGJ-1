extends Control

@export var splashes:Array[PackedScene]
@export var game_scene:PackedScene

var active_screen:Control
var startup_tween:Tween

func _ready():
	load_splash()
	return

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("select"):
		accept_event()
		startup_tween.pause()
		startup_tween.custom_step(99)
	return

func load_splash():
	if splashes.size() > 0:
		active_screen = splashes.pop_front().instantiate()
		start_tween(load_splash)
	else:
		load_title_screen()
	return

func load_title_screen():
	var game:Game = game_scene.instantiate()
	get_tree().get_root().add_child(game)
	queue_free()
	return

func start_tween(next_func:Callable):
	active_screen.modulate = Color.BLACK
	add_child(active_screen)
	startup_tween = get_tree().create_tween()
	startup_tween.tween_interval(1)
	startup_tween.tween_property(active_screen, "modulate", Color.WHITE, 2)
	startup_tween.tween_interval(3)
	startup_tween.tween_property(active_screen, "modulate", Color.BLACK, 2)
	startup_tween.tween_interval(1)
	startup_tween.tween_callback(active_screen.queue_free)
	startup_tween.tween_callback(next_func)
	return
