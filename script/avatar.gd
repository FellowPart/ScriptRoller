extends PanelContainer

@onready var avatar_icon = $HBoxContainer/MarginContainer/AvatarIcon
@onready var avatar_name = $HBoxContainer/MarginContainer2/AvatarName
@onready var order = $HBoxContainer/MarginContainer3/Order

#avatar_setter方法读取字典拿name和icon_path，设置头像和名字

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reset_order(_index: int):
	order.text = str(_index)

func avatar_setter(data: Dictionary):
	avatar_icon.set_texture(
		ImageTexture.create_from_image(
			Image.load_from_file(data["icon_path"])))
	avatar_name.set_text(data["avatar_name"])
	name = data["avatar_name"]
