extends CharacterBody2D
class_name Player

@export var movement : PlayerMovementData

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var health_module: HealthModule = $HealthModule
@onready var hurt_box: HurtBox = $HurtBox
@onready var shield_module: ShieldModule = $HealthModule/ShieldModule

var direction = -1

func _ready():
	state_machine.init(self)
	state_machine.start()
	hurt_box.hurt.connect(shield_module.take_damage)
	shield_module.no_shield.connect(health_module.take_damage)
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
	var input:Vector2 = Vector2(input_axis_h, input_axis_v).normalized()
	velocity.x = move_toward(velocity.x, movement.speed * input.x, movement.acceleration * delta)
	velocity.y = move_toward(velocity.y, movement.speed * input.y, movement.acceleration * delta)
	return

func update_animations(input_axis):
	if input_axis != 0:
		sprite_2d.flip_h = (input_axis > 0)
	return

func start_animation(animation:String):
	animation_player.play(animation)
	return


func _on_animation_player_current_animation_changed(_animation_name: String) -> void:
	#print("Animation Started: ", animation_name)
	return
