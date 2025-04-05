extends Node
class_name StateMachine

@export var starting_state: State

var current_state: State

func init(parent: Node):
	for child in get_children():
		child.parent = parent
	return

func change_state(new_state: State):
	if current_state:
		current_state.exit()

	current_state = new_state
	print("Change State to: " + current_state.name)
	current_state.enter()
	return

func process_frame(delta: float):
	if(current_state == null): return
	var new_state = current_state.process_frame(delta)

	if new_state:
		change_state(new_state)
	return

func process_physics(delta: float):
	if(current_state == null): return
	var new_state = current_state.process_physics(delta)

	if new_state:
		change_state(new_state)
	return

func process_input(event: InputEvent):
	if(current_state == null): return
	var new_state = current_state.process_input(event)

	if new_state:
		change_state(new_state)
	return

func start():
	change_state(starting_state)
	return
