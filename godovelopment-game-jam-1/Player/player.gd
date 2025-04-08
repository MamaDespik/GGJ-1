extends CharacterBody2D
class_name Player

@export var movement : PlayerMovementData

var direction:int
var movement_disabled:int = 0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var health_module: HealthModule = $HealthModule
@onready var hurt_box: HurtBox = $HurtBox
@onready var shield_module: ShieldModule = $HealthModule/ShieldModule
@onready var card_actions: Node2D = $CardActions

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

func handle_acceleration(input:Vector2, delta:float):
	input = input.normalized()
	velocity.x = move_toward(velocity.x, movement.speed * input.x, movement.acceleration * delta)
	velocity.y = move_toward(velocity.y, movement.speed * input.y, movement.acceleration * delta)
	return

func start_animation(animation:String):
	animation_player.play(animation)
	return

func _on_animation_player_current_animation_changed(_animation_name: String) -> void:
	#print("Animation Started: ", animation_name)
	return
