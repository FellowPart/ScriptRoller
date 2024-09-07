extends PanelContainer
@onready var aside_edit = $MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/AsideEdit
@onready var aside_label = $MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/AsideLabel

var type = "NarratorSetter"
var data: Dictionary = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	set_data()
	pass # Replace with function body.

	
func set_data():
	data["TYPE"] = type
	data["action"] = {
		"line" : aside_label.text
	}

func get_data():
	return data

func set_label(data: String):
	aside_label.text = data
	set_data()

func edit():
	toggle_visible()
	#for node in get_tree().get_nodes_in_group("editNode"):
		#node.visible = !node.visible
	if aside_label.visible:
		aside_label.text = aside_edit.text
		set_data()
	else:
		aside_edit.text = aside_label.text

func toggle_visible():
	aside_edit.visible = !aside_edit.visible
	aside_label.visible = !aside_label.visible

func self_destory():
	self.queue_free()
