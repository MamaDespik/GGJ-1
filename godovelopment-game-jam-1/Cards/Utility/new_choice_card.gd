extends Card
class_name NewChoiceCard

@export var text_first_half:String = "Spend "
@export var text_second_half:String = " gold to add a new card choice. "


func _ready() -> void:
	card_text = text_first_half + str(use_cost) + text_second_half
	super()
	return
