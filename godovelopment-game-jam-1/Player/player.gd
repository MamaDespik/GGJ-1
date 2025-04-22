extends CharacterBody2D
class_name Player

@export var movement : PlayerMovementData
@export var gold_count:int = 0:
	set(value):
		gold_count = value
		new_gold_count.emit(gold_count)

var direction:int = 1
var movement_disabled:int = 0
var boosting:bool = false
var speed_ratio:float = 1

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var health_module: HealthModule = $HealthModule
@onready var hurt_box: HurtBox = $HurtBox
@onready var shield_module: ShieldModule = $HealthModule/ShieldModule
@onready var card_actions: Node2D = $CardActions
@onready var invincibility_timer: Timer = $InvincibilityTimer

signal new_gold_count(int)
signal got_relic(Drop)

func _ready():
	state_machine.init(self)
	state_machine.start()
	hurt_box.hurt.connect(shield_module.take_damage)
	hurt_box.hurt.connect(start_invincibility)
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
	velocity *= speed_ratio
	return

func start_animation(animation:String):
	animation_player.play(animation)
	return

func start_invincibility(damage:int):
	if damage <= 0: return
	sprite_2d.material.set_shader_parameter("active", true)
	hurt_box.set_deferred("enabled", false)
	invincibility_timer.start()
	return

func stop_invincibility():
	sprite_2d.material.set_shader_parameter("active", false)
	hurt_box.set_deferred("enabled", true)
	invincibility_timer.stop()
	return

func get_relic(relic:Drop):
	got_relic.emit(relic)
	return

func set_direction(new_direction:int):
	direction = new_direction
	sprite_2d.flip_h = direction==-1
	return

func _on_animation_player_current_animation_changed(_animation_name: String) -> void:
	#print("Animation Started: ", animation_name)
	return

func _on_invincibility_timer_timeout() -> void:
	stop_invincibility()
	return
