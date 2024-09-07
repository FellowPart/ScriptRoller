extends PanelContainer
@onready var background = $Background
signal cut_scene
signal background_switch

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_data(data: Dictionary):
	if data["TYPE"] == "BackgroundSetter":
		cut_scene.emit()
		await get_tree().create_timer(0.4).timeout
		image_setter(data["action"]["background_name"])
	else:
		pass
	pass

func image_setter(file_name: String):
	var path = Common.background_list[file_name]
	background.set_texture(
		ImageTexture.create_from_image(
			Image.load_from_file(path)
		)
	)
	background_switch.emit()
