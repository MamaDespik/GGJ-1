extends CharacterBody2D
class_name Player

@export var movement : PlayerMovementData

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var direction = -1

func _ready():
	state_machine.init(self)
	state_machine.start()
	return

func _process(delta):
	state_machine.process_frame(delta)
	return

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	return

func _input(event):
	state_machine.process_input(event)
	return


func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, movement.friction * delta)
	velocity.y = move_toward(velocity.y, 0, movement.friction * delta)
	return

func handle_acceleration(input_axis_h:float, input_axis_v:float, delta:float):
	velocity.x = move_toward(velocity.x, movement.speed * input_axis_h, movement.acceleration * delta)
	velocity.y = move_toward(velocity.y, movement.speed * input_axis_v, movement.acceleration * delta)
	return

func update_animations(input_axis):
	if input_axis != 0:
		sprite_2d.flip_h = (input_axis > 0)
	return

func start_animation(animation:String):
	animation_player.play(animation)
	return


func _on_animation_player_current_animation_changed(name: String) -> void:
	print("Animation Started: ", name)
