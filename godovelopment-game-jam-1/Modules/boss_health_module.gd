extends HealthModule

@onready var progress_bar: ProgressBar = %ProgressBar

func _ready() -> void:
	progress_bar.max_value = max_health
	progress_bar.value = max_health
	super()


func adjust_health(adjustment:int):
	current_health += adjustment
	progress_bar.value = current_health
	return
