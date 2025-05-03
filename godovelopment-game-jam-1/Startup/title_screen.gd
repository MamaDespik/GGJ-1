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
@onready var hand: Hand = $MarginContainer/Hand
@onready var background_holder: MarginContainer = %BackgroundHolder
@onready var bgm: AudioStreamPlayer = $BGM

signal deck_selected(deck:CardPile)

func _ready() -> void:
	start_button.grab_focus()
	main_buttons.show()
	deck_buttons.hide()
	return

func show_deck(deck:CardPile):
	hide_deck()
	add_child(deck)
	for i in deck.cards.size():
		var card:Card = deck.draw()
		card.disabled = true
		card.simulated = true
		hand.add_card(card)
	var tween:Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(background_holder, "theme_override_constants/margin_left", 960, .5)
	return

func hide_deck():
	for i in hand.cards.size():
		hand.cards[0].discard()
	var tween:Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(background_holder, "theme_override_constants/margin_left", 0, .5)

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
	hide_deck()
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

func _on_warrior_button_focus_entered() -> void:
	var deck:CardPile = warrior_deck_scene.instantiate()
	show_deck(deck)
	deck.queue_free()
	return

func _on_warrior_button_mouse_entered() -> void:
	var deck:CardPile = warrior_deck_scene.instantiate()
	show_deck(deck)
	deck.queue_free()
	return

func _on_archer_button_focus_entered() -> void:
	var deck:CardPile = archer_deck_scene.instantiate()
	show_deck(deck)
	deck.queue_free()
	return

func _on_archer_button_mouse_entered() -> void:
	var deck:CardPile = archer_deck_scene.instantiate()
	show_deck(deck)
	deck.queue_free()
	return

func _on_rogue_button_focus_entered() -> void:
	var deck:CardPile = rogue_deck_scene.instantiate()
	show_deck(deck)
	deck.queue_free()
	return

func _on_rogue_button_mouse_entered() -> void:
	var deck:CardPile = rogue_deck_scene.instantiate()
	show_deck(deck)
	deck.queue_free()
	return

func _on_arcanist_button_focus_entered() -> void:
	var deck:CardPile = arcanist_deck_scene.instantiate()
	show_deck(deck)
	deck.queue_free()
	return

func _on_arcanist_button_mouse_entered() -> void:
	var deck:CardPile = arcanist_deck_scene.instantiate()
	show_deck(deck)
	deck.queue_free()
	return
