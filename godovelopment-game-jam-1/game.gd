extends Node2D
class_name Game

@export var region_scenes:Array[PackedScene]
@export var player_scene:PackedScene
@export var cards_container_scene:PackedScene

var current_region:Region
var current_floor:Floor
var game_active:bool = false
var original_region_scenes:Array[PackedScene]

@onready var player:Player = %Player
@onready var floor_container = %FloorContainer
@onready var cards_container: CardsContainer = %CardsContainer
@onready var fader: ColorRect = %Fader
@onready var health_display: Control = %HealthDisplay
@onready var gold_label: Label = %GoldLabel
@onready var relic_container: VBoxContainer = %RelicContainer
@onready var title_screen: Control = %TitleScreen
@onready var game_view: MarginContainer = %GameView
@onready var player_container: Node2D = %PlayerContainer
@onready var cards_container_holder: Node2D = %CardsContainerHolder

func _ready():
	title_screen.show()
	game_view.hide()
	original_region_scenes = region_scenes.duplicate()
	return

func get_next_floor():
	if current_region.floor_lengths.size() > 0:
		if current_floor: current_floor.queue_free()
		current_floor = current_region.get_floor()
		current_floor.player = player
		current_floor.start_choice.connect(_on_floor_start_choice)
		current_floor.floor_cleared.connect(_on_floor_cleared)
		floor_container.add_child(current_floor)
		cards_container.draw_hand()
	else:
		if region_scenes.size() > 0:
			current_region.queue_free()
			current_region = region_scenes.pop_front().instantiate()
			get_next_floor()
		else:
			#TODO
			print("You won the game!")
	return

func get_shop():
	current_floor.queue_free()
	current_floor = current_region.get_shop()
	current_floor.player = player
	current_floor.floor_cleared.connect(_on_shop_cleared)
	floor_container.add_child(current_floor)
	current_floor.start_room.deck = cards_container.draw_pile
	return

func clear_hand():
	var cards_to_remove:Array[Card]
	for card_in_hand:Card in cards_container.hand.cards:
		cards_to_remove.append(card_in_hand)
	for card:Card in cards_to_remove:
		card.discard()
	return

func start_game():
	game_active = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player.health_module.reparent(health_display)
	player.health_module.rotate()
	player.shield_module.reparent(health_display)
	player.shield_module.rotate()
	player.new_gold_count.connect(_on_player_new_gold_count)
	player.got_relic.connect(_on_player_got_relic)
	player.died.connect(_on_player_died)
	player.gold_count = 0
	cards_container.player = player
	cards_container.initialize()
	current_region = region_scenes.pop_front().instantiate()
	var tween:Tween = create_tween()
	tween.tween_interval(.2)
	tween.tween_property(fader, "color", Color(0,0,0,1), .5)
	tween.tween_property(title_screen.bgm, "volume_db", -40, .5)
	tween.tween_callback(title_screen.hide)
	tween.tween_callback(game_view.show)
	tween.tween_callback(get_next_floor)
	tween.tween_property(fader, "color", Color(0,0,0,0), .5)
	return

func reset_player():
	#Reset
	player.health_module.queue_free()
	player.shield_module.queue_free()
	player.queue_free()
	for node:Node in relic_container.get_children():
		node.queue_free()
	player = player_scene.instantiate()
	player_container.add_child(player)
	player.position = Vector2(930,523)
	return

func reset_cards_container():
	#Reset CardContainer
	cards_container.queue_free()
	cards_container = cards_container_scene.instantiate()
	cards_container_holder.add_child(cards_container)
	return

func _on_floor_cleared(card:Card):
	card.player = player
	card.comboed.connect(cards_container._on_card_comboed)
	card.cards_container = cards_container
	var tween:Tween = create_tween()
	tween.tween_callback(cards_container.draw_pile.add_card.bind(card))
	tween.tween_interval(1)
	tween.tween_callback(cards_container.shuffle_discard)
	tween.tween_property(cards_container, "paused", false, 0)
	tween.tween_interval(.2)
	tween.tween_property(fader, "color", Color(0,0,0,1), .5)
	tween.tween_callback(get_shop)
	tween.tween_property(player, "position", Vector2(960, 540), 0).set_delay(1)
	tween.tween_property(fader, "color", Color(0,0,0,0), .5)
	return

func _on_shop_cleared():
	var tween:Tween = create_tween()
	tween.tween_property(fader, "color", Color(0,0,0,1), .5)
	tween.tween_callback(get_next_floor)
	tween.tween_property(player, "position", Vector2(960, 540), 0).set_delay(1)
	tween.tween_property(fader, "color", Color(0,0,0,0), .5)
	return

func _on_floor_start_choice():
	var tween:Tween = create_tween()
	tween.tween_property(cards_container, "paused", true, 0)
	tween.tween_interval(1.5)
	tween.tween_callback(clear_hand)
	tween.tween_callback(current_floor.card_picker.pick_cards)
	return

func _on_player_new_gold_count(gold:int):
	gold_label.text = str(gold) + "G"
	return

func _on_player_got_relic(relic:Drop):
	var holder:TextureRect = TextureRect.new()
	holder.texture = relic.sprite_2d.texture
	relic_container.add_child(holder)
	return

func _on_title_screen_deck_selected(deck: CardPile) -> void:
	if game_active: return
	cards_container.draw_pile = deck
	cards_container.add_child(deck)
	start_game()
	return

func _on_player_died():
	#Restore Regions
	region_scenes = original_region_scenes.duplicate()

	game_active = false
	title_screen._on_back_button_pressed()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var tween:Tween = create_tween()
	tween.tween_interval(3)
	tween.tween_property(fader, "color", Color(0,0,0,1), .5)
	tween.tween_callback(current_floor.queue_free)
	tween.tween_callback(current_region.queue_free)
	tween.tween_callback(reset_player)
	tween.tween_callback(reset_cards_container)
	tween.tween_callback(title_screen.show)
	tween.tween_callback(game_view.hide)
	tween.tween_property(title_screen.bgm, "volume_db", 0, 1)
	tween.tween_property(fader, "color", Color(0,0,0,0), .5)
	return
