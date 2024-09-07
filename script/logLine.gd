extends PanelContainer
@onready var avatar_name = $MarginContainer/HBoxContainer/Name
@onready var rich_text_label = $MarginContainer/HBoxContainer/RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_data(data: Dictionary):
	if data["action"].has("avatar"):
		avatar_name.text = data["action"]["avatar"] 
	else :
		avatar_name.visible = false
	rich_text_label.clear()
	rich_text_label.text = data["action"]["line"]
