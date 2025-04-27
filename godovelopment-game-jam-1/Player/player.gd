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
var cloaked:int = 0
var damage_negation:int = 0:
	set(value):
		damage_negation = value
		check_damage_negation()
		return
var target_position:Vector2
var bonus_damage:int = 0
var reshuffle_cost:int = 0

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
signal shuffle_time_reduced
signal hand_size_increased
signal reshuffle_damage_added

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
	damage_negation += 1
	invincibility_timer.start()
	return

func stop_invincibility():
	sprite_2d.material.set_shader_parameter("active", false)
	damage_negation -= 1
	invincibility_timer.stop()
	return

func check_damage_negation():
	if damage_negation > 0:
		hurt_box.set_deferred("enabled", false)
	else:
		hurt_box.set_deferred("enabled", true)
	return

func get_relic(relic:Drop):
	got_relic.emit(relic)
	return

func set_direction(new_direction:int):
	direction = new_direction
	sprite_2d.flip_h = direction==-1
	return

func get_player_position()->Vector2:
	var return_position:Vector2
	if cloaked < 1:
		return_position = global_position
	else:
		return_position = Vector2(9999,9999)
	return return_position

func set_stealth_practical(stealth_on:bool):
	if stealth_on:
		cloaked += 1
	else:
		cloaked -= 1
	return

func set_stealth_visuals(stealth_on:bool):
	if stealth_on:
		sprite_2d.material.set_shader_parameter("cloaked", true)
	else:
		sprite_2d.material.set_shader_parameter("cloaked", false)
	return

func reduce_shuffle_time():
	shuffle_time_reduced.emit()
	return

func increase_hand_size():
	hand_size_increased.emit()
	return

func add_reshuffle_damage():
	reshuffle_damage_added.emit()
	return

func _on_animation_player_current_animation_changed(_animation_name: String) -> void:
	#print("Animation Started: ", animation_name)
	return

func _on_invincibility_timer_timeout() -> void:
	stop_invincibility()
	return
