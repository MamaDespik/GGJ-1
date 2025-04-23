extends StaticBody2D
class_name Enemy

@export var sight_range:float = 500
@export var attack_range:float = 200
@export var speed:float = 300
@export var player:Player

@onready var health_module: HealthModule = $HealthModule
@onready var state_machine: StateMachine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurt_box: HurtBox = $HurtBox
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hit_box: HitBox = $HitBox
@onready var drop_module: DropModule = $DropModule
@onready var attack = $Attack
@onready var attack_collision_shape = $Attack/HitBox/Area2D/CollisionShape2D

@warning_ignore("unused_signal")
signal died(enemy:Enemy)

func _ready() -> void:
	state_machine.init(self)
	state_machine.start()
	hurt_box.hurt.connect(health_module.take_damage)
	return

func _process(delta):
	state_machine.process_frame(delta)
	return

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	return

func disable_all_detection():
	collision_shape_2d.disabled = true
	hit_box.enabled = false
	attack_collision_shape.disabled = true
	attack.hide()
	return

func get_player_position() -> Vector2:
	var player_position:Vector2
	player_position = player.get_player_position()
	return player_position
