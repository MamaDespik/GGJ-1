extends Control

@export var warrior_deck_scene:PackedScene
@export var archer_deck_scene:PackedScene
@export var rogue_deck_scene:PackedScene
@export var arcanist_deck_scene:PackedScene

@onready var start_button: Button = %StartButton
@onready var options_button: Button = %OptionsButton
@onready var quit_button: Button = %QuitButton
@onready var main_buttons: BoxContainer = %MainButtons
@onready var deck_buttons: BoxContainer = %DeckButtons
@onready var warrior_button: Button = %WarriorButton
@onready var archer_button: Button = %ArcherButton
@onready var rogue_button: Button = %RogueButton
@onready var arcanist_button: Button = %ArcanistButton

signal deck_selected(deck:CardPile)

func _ready() -> void:
	start_button.grab_focus()
	main_buttons.show()
	deck_buttons.hide()
	return

func _on_start_button_pressed() -> void:
	main_buttons.hide()
	deck_buttons.show()
	warrior_button.grab_focus()
	return

func _on_options_button_pressed() -> void:
	print("options")
	return

func _on_quit_button_pressed() -> void:
	get_tree().quit()
	return

func _on_back_button_pressed() -> void:
	start_button.grab_focus()
	main_buttons.show()
	deck_buttons.hide()
	return

func _on_warrior_button_pressed() -> void:
	deck_selected.emit(warrior_deck_scene.instantiate())
	return

func _on_archer_button_pressed() -> void:
	deck_selected.emit(archer_deck_scene.instantiate())
	return

func _on_rogue_button_pressed() -> void:
	deck_selected.emit(rogue_deck_scene.instantiate())
	return

func _on_arcanist_button_pressed() -> void:
	deck_selected.emit(arcanist_deck_scene.instantiate())
	return
