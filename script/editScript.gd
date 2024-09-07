extends Control
@onready var avatar_box = $PanelContainer/MarginContainer/VBoxContainer/CharacterAndDialog/Character/VBox/MarginContainer/ScrollContainer/AvatarBox
@onready var set_avatar = $PanelContainer/MarginContainer/VBoxContainer/CharacterAndDialog/Character/VBox/Button/SetAvatar
@onready var save_btn = $PanelContainer/MarginContainer/VBoxContainer/HBox/SaveBtn
@onready var script_roller = $PanelContainer/MarginContainer/VBoxContainer/CharacterAndDialog/Dialog/DialogueScroll/Margin/VBox/ScriptRoller
@onready var avatar_selecter_box = $PanelContainer/AvatarSelecter/PanelContainer/MarginContainer/ScrollContainer/MarginContainer/AvatarSelecterBox
@onready var avatar_selecter = $PanelContainer/AvatarSelecter
var avatar_scene = preload("res://scenes/avatar.tscn")
var active_avatar_list:Array[String]

func _ready():
	Common.load_script()
	set_avatar.pressed.connect(call_avatar_list)
	save_btn.pressed.connect(save_script_roller)
	bulid_from_script()
	avatar_selecter_setter()
	pass # Replace with function body.

func full_screen_exit_avatar_list(event):
	if event is InputEventMouseButton\
	and event.button_index == MOUSE_BUTTON_LEFT\
	and event.is_pressed():
		call_avatar_list()

func avatar_selecter_setter():
	var list = Common.avatar_list
	for item in list:
		var avatar_unit = HBoxContainer.new()
		var check_box = CheckBox.new()
		var avatar_slot = avatar_scene.instantiate()
		var data = {
			"avatar_name" : item,
			"icon_path" : list[item]["folder_path"]+list[item]["avatar_picture"]
		}
		if Common.current_avatar_list.has(data["avatar_name"]):
			check_box.button_pressed = true
		avatar_slot.call_deferred("avatar_setter",data)
		avatar_slot.get_node("HBoxContainer/MarginContainer3/Order").visible = false
		avatar_unit.add_child(check_box)
		avatar_unit.add_child(avatar_slot)
		avatar_selecter_box.add_child(avatar_unit)


func reset_avatar_box(list: Array[String]):
	for item in avatar_box.get_children():
		item.queue_free()
	for item in list:
		var avatar = avatar_scene.instantiate()
		var data = {
			"avatar_name" : item,
			"icon_path" : Common.avatar_list[item]["folder_path"]\
			+Common.avatar_list[item]["avatar_picture"]
			}
		avatar.call_deferred("avatar_setter",data)
		avatar.call_deferred("reset_order",list.bsearch(item)+1)
		avatar_box.add_child(avatar)
		
func call_avatar_list():
	avatar_selecter.visible = !avatar_selecter.visible
	if !avatar_selecter.visible:
		for child in avatar_selecter_box.get_children(false):
			if child.get_child(0).is_pressed():
				active_avatar_list.append(child.get_child(1).name)
		reset_avatar_box(active_avatar_list)
		Common.current_avatar_list = active_avatar_list
		get_node("PanelContainer/MarginContainer/VBoxContainer/CharacterAndDialog/Dialog/DialogueScroll/Margin/VBox/ScriptRoller")\
		.option_button_setter(active_avatar_list)
	else:
		active_avatar_list.clear()

func save_script_roller():
	var file = AutoFileAccess.new()
	var script_data : Dictionary = {}
	var lines: Dictionary = {}
	var script_avatar_list : Dictionary = {}
	var children = script_roller.get_node("./VBox/Roller/Scroll/MarginContainer/LineBox").get_children()
	for child in children:
		lines["line"+str(child.get_index())] = child.get_data()
	for item in Common.current_avatar_list:
		script_avatar_list[item] = item
	script_data["script_name"] = Common.current_script_name
	script_data["avatar_list"] = script_avatar_list
	script_data["lines"] = lines
	file.save_script(script_data)

func bulid_from_script():
	if Common.load_script():
		script_roller.recover_from_script(Common.current_script["lines"])

func back_to_main_scene():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
