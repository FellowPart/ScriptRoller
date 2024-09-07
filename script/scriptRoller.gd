extends PanelContainer

@onready var line_box = $VBox/Roller/Scroll/MarginContainer/LineBox
@onready var avatar = $VBox/Speaker/MarginContainer/HBox/VBoxContainer/Avatar
@onready var state = $VBox/Speaker/MarginContainer/HBox/VBoxContainer/State
@onready var line = $VBox/Speaker/MarginContainer/HBox/Line

@onready var submit = $VBox/Speaker/MarginContainer/HBox/Submit
@onready var background_btn = $VBox/HBox/BackgroundBtn
@onready var music_btn = $VBox/HBox/MusicBtn
@onready var button = $VBox/Speaker/MarginContainer/HBox/VBoxContainer/Button

@onready var scroll = $VBox/Roller/Scroll

var line_scene = preload("res://scenes/singleLine.tscn")
var background_scene = preload("res://scenes/backgroundSetter.tscn")
var music_scene = preload("res://scenes/musicSetter.tscn")
var narrator_scene = preload("res://scenes/narratorSetter.tscn")

var lines: Dictionary
var current_line: Dictionary

func _ready():
	submit.pressed.connect(add_line)
	#滚动条自动设置到最大值
	scroll.get_v_scroll_bar().changed.connect(
		func(): scroll.get_v_scroll_bar().set_value(
			scroll.get_v_scroll_bar().max_value
		)
	)

func _input(event):
	#快捷键
	if event is InputEventKey\
	and event.is_alt_pressed()\
	and event.is_pressed():
		var flag: int
		match event.keycode:
			KEY_1: flag = 0
			KEY_2: flag = 1
			KEY_3: flag = 2
			KEY_4: flag = 3
			KEY_5: flag = 4
			KEY_6: flag = 5
			KEY_7: flag = 6
			KEY_8: flag = 7
			KEY_9: flag = 8
			KEY_0: flag = 9
			KEY_ENTER: 
				add_line()
				return
		manual_select(flag)
		#if avatar.has_selectable_items() and flag < avatar.item_count:
			#avatar.select(flag)
			#state_button_setter(flag)

func manual_select(index: int):
	if avatar.has_selectable_items() and index < avatar.item_count:
		avatar.select(index)
		state_button_setter(index)

func option_button_setter(current_list: Array[String]):
	avatar.clear()
	for item in current_list:
		avatar.add_item(item,current_list.find(item))
		avatar.set_item_metadata(
			current_list.find(item),
			Common.avatar_list[item]
			)
	state_button_setter(0)


func state_button_setter(index: int):
	state.clear()
	if avatar.has_selectable_items():
		var data = avatar.get_item_metadata(index)["states"]
		for i in range(data.keys().size()):
			state.add_item(data.keys()[i],i)
			if data.keys()[i] == "default":
				state.select(i)

func add_line():
	var text: String = line.get_text()
	text = text.strip_edges()
	if text.length() != 0:
		var single_line = line_scene.instantiate()
		current_line["avatar"] = avatar.get_item_text(avatar.selected)
		current_line["line"] = line.get_text()
		current_line["stage"] = button.button_pressed
		if state.has_selectable_items():
			current_line["state"] = state.get_item_text(state.selected)
		else:
			current_line["state"] = ""
		current_line["avatar_icon"] \
		= avatar.get_item_metadata(avatar.selected)["folder_path"]\
		+ avatar.get_item_metadata(avatar.selected)["avatar_picture"]
		single_line.call_deferred("set_data",current_line)
		single_line.name = "item" + str(line_box.get_child_count(false))
		line_box.add_child(single_line)
		lines[str(line_box.get_child_count(false))] = current_line
	line.clear()
	scroll.get_v_scroll_bar().value \
	= scroll.get_v_scroll_bar().max_value - scroll.get_v_scroll_bar().page

func set_button(flag: bool):
	if flag:
		button.text = "上场"
	else:
		button.text = "下场"

func add_background_setter():
	var background = background_scene.instantiate()
	background.name = "item" + str(line_box.get_child_count(false))
	line_box.add_child(background)

func add_music_setter():
	var music = music_scene.instantiate()
	music.name = "item" + str(line_box.get_child_count(false))
	line_box.add_child(music)
	pass

func add_narrator_setter():
	var narrator = narrator_scene.instantiate()
	narrator.name = "item" + str(line_box.get_child_count(false))
	line_box.add_child(narrator)

func get_data():
	var lines_arr: Array[Node]
	lines_arr = line_box.get_children()
	for item in lines_arr:
		item.call_deferred("get_data")

#从data加载进line_box
func recover_from_script(data: Dictionary):
	for item in data.values():
		match item["TYPE"]:
			"SingleLine":
				var single_line = line_scene.instantiate()
				single_line.call_deferred("set_data",item["action"])
				#single_line.set_data(item["action"])
				single_line.name = "item" + str(line_box.get_child_count(false))
				line_box.add_child(single_line)
			"MusicSetter":
				var music = music_scene.instantiate()
				music.name = "item" + str(line_box.get_child_count(false))
				line_box.add_child(music)
				music.set_op_button(item["action"]["music_name"])
			"BackgroundSetter":
				var background = background_scene.instantiate()
				background.name = "item" + str(line_box.get_child_count(false))
				line_box.add_child(background)
				background.set_op_button(item["action"]["background_name"])
			"NarratorSetter":
				var narrator = narrator_scene.instantiate()
				narrator.name = "item" + str(line_box.get_child_count(false))
				line_box.add_child(narrator)
				narrator.set_label(item["action"]["line"])

func edit_line(data: Dictionary):
	line.set_text(data["line"])
	avatar._select_int(data["avatar"])
	state._select_int(data["state"])

