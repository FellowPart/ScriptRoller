extends Control
@onready var edit_button = $PanelContainer/CenterContainer/GridContainer2/EditButton
@onready var play_button = $PanelContainer/CenterContainer/GridContainer2/PlayButton
@onready var script_selelcter = $PanelContainer/ScriptSelelcter
@onready var add_script = $PanelContainer/AddScript
@onready var script_name = $PanelContainer/AddScript/AddScript/MarginContainer/HBoxContainer/LineEdit
@onready var script_item_box = $PanelContainer/ScriptSelelcter/PanelContainer/VBoxContainer/MarginContainer/ScrollContainer/ScriptItemBox
@onready var add_script_btn = $PanelContainer/ScriptSelelcter/PanelContainer/VBoxContainer/MarginContainer2/AddScriptBtn
@onready var play_selelcter = $PanelContainer/PlaySelelcter
@onready var play_item_box = $PanelContainer/PlaySelelcter/PanelContainer/VBoxContainer/MarginContainer/ScrollContainer/ScriptItemBox

var script_item = preload("res://scenes/scriptItem.tscn")
var play_item = preload("res://scenes/playItem.tscn")
#@onready var script_item = load("res://scenes/ScriptItem.tscn")
#@onready var play_item = load("res://scenes/playItem.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	opening_effect()
	play_button.pressed.connect(switch_to_play_menu)
	edit_button.pressed.connect(switch_to_edit_menu)
	pass # Replace with function body.

func shutdown_program():
	get_tree().quit()

func toggle_fullscreen(flag: bool):
	if flag:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2(1920,1080))

func opening_effect():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"modulate",Color.WHITE,0.6)
	await tween.finished

func switch_to_play_menu():
	play_selelcter.visible = true
	set_play_selelcter_data()
	pass

func switch_to_edit_menu():
	script_selelcter.visible = true
	set_script_selelcter_data()
	#get_tree().change_scene_to_file("res://scenes/editScript.tscn")

func switch_to_name_new_script():
	add_script.visible = true

func set_script_selelcter_data():
	Common.refresh_list()
	for child in script_item_box.get_children():
		child.queue_free()
	for item in Common.script_list.keys():
		var script_item_scene = script_item.instantiate()
		script_item_scene.call_deferred("set_data",item)
		script_item_box.add_child(script_item_scene)

func set_play_selelcter_data():
	Common.refresh_list()
	for child in play_item_box.get_children():
		child.queue_free()
	for item in Common.script_list.keys():
		var play_item_scene = play_item.instantiate()
		play_item_scene.get_node("MarginContainer/HBoxContainer/DeleteBtn").visible = false
		play_item_scene.call_deferred("set_data",item)
		play_item_box.add_child(play_item_scene)

func close_script_selelcter_visibility(event):
	if event is InputEventMouseButton\
	and event.button_index == MOUSE_BUTTON_LEFT\
	and event.is_pressed():
		script_selelcter.visible = false

func close_add_script_visibility(event):
	if event is InputEventMouseButton\
	and event.button_index == MOUSE_BUTTON_LEFT\
	and event.is_pressed():
		add_script.visible = false

func close_play_selelcter_visibility(event):
	if event is InputEventMouseButton\
	and event.button_index == MOUSE_BUTTON_LEFT\
	and event.is_pressed():
		play_selelcter.visible = false

func chose_exist_script(file_name: String):
	Common.current_script_name = file_name
	get_tree().change_scene_to_file("res://scenes/editScript.tscn")

func create_new_script():
	var _name = script_name.get_text()
	if Common.script_list.has(_name):
		script_name.clear()
		return
	else:
		Common.current_script_name = _name
		get_tree().change_scene_to_file("res://scenes/editScript.tscn")
