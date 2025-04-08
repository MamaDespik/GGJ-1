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
