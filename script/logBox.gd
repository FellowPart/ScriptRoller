extends MarginContainer
@onready var log_box = $Panel/Scroll/Margin/VBox/LogBox
var log_line_scene = preload("res://scenes/logLine.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_data(data: Dictionary):
	match data["TYPE"]:
		"SingleLine":
			add_log_item(data)
		"NarratorSetter":
			add_log_item(data)
	

func close_log_box_visibility(event):
	if event is InputEventMouseButton\
	and event.button_index == MOUSE_BUTTON_LEFT\
	and event.is_pressed():
		self.visible = false

func add_log_item(data: Dictionary):
	var log_line = log_line_scene.instantiate()
	log_box.add_child(log_line)
	log_line.set_data(data)
	log_line = "line"+str(log_box.get_child_count())
