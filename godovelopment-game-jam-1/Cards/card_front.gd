extends MarginContainer
class_name CardFront

@export var title:String
@export var image:Texture
@export var description:String


@onready var title_lable = %TitleLable
@onready var image_texture = %Image
@onready var description_label = %DescriptionLabel

func _ready():
	title_lable.text = title
	image_texture.texture = image
	description_label.text = description
	return
