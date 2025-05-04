extends MarginContainer

@onready var resume_button: Button = $VBoxContainer/ResumeButton

signal quit

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		resume()
	return

func resume():
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	return


func _on_resume_button_pressed() -> void:
	resume()
	return


func _on_quit_button_button_pressed() -> void:
	resume()
	quit.emit()
	return


func _on_draw() -> void:
	resume_button.grab_focus()
	return
