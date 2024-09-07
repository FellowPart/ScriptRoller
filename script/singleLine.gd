extends PanelContainer
signal slot_data(data: Dictionary)
@onready var avatar_icon = $MarginContainer/HBoxContainer/AvatarIcon
@onready var avatar_name = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/AvatarName
@onready var state = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/State
@onready var line = $MarginContainer/HBoxContainer/VBoxContainer/Line
@onready var edit_button = $MarginContainer/HBoxContainer/EditButton
@onready var op_avatar = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/AvatarOptionButton
@onready var op_state = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/StateOptionButton
@onready var text_edit = $MarginContainer/HBoxContainer/VBoxContainer/TextEdit
@onready var button = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Button

var type: String = "SingleLine"
var data: Dictionary

var normal_node_group: Array[Node]
var edit_node_group: Array[Node]

const AVATAR = "avatar"
const AVATAR_ICON = "avatar_icon"
const STATE = "state"
const LINE = "line"
const STAGE = "stage"

# Called when the node enters the scene tree for the first time.
func _ready():
	normal_node_group = [avatar_name,state,line]
	edit_node_group = [op_avatar,op_state,text_edit]
	edit_button.pressed.connect(edit)
	pass # Replace with function body.


func set_data(_data: Dictionary):
	self.data[AVATAR] = _data[AVATAR]
	self.data[STATE] = _data[STATE]
	self.data[LINE] = _data[LINE]
	self.data[STAGE] = _data[STAGE]
	set_node_data()

func get_data():
	return {
		"TYPE" : type,
		"action" : self.data
	}


func edit():
	if op_avatar.selected != -1 or !op_avatar.visible:
		var flag: bool
		toggle_visibility(normal_node_group)
		flag = toggle_visibility(edit_node_group)
		if flag:
			set_op_avatar()
			set_text_edit()
		else:
			self.data[AVATAR] = op_avatar.get_item_text(op_avatar.selected)
			#self.data[AVATAR_ICON] \
				#= Common.avatar_list[self.data[AVATAR]]["folder_path"]\
				#+ Common.avatar_list[self.data[AVATAR]]["avatar_picture"]
			if op_state.has_selectable_items():
				self.data[STATE] = op_state.get_item_text(op_state.selected)
			self.data[LINE] = text_edit.text
			set_node_data()

func set_node_data():
	avatar_name.set_text(str(self.data[AVATAR]))
	state.set_text(str(self.data[STATE]))
	line.set_text(str(self.data[LINE]))
	avatar_icon.set_texture(
		ImageTexture.create_from_image(
			Image.load_from_file(
				Common.avatar_list[self.data[AVATAR]]["folder_path"]\
				+ Common.avatar_list[self.data[AVATAR]]["avatar_picture"])))
	button.button_pressed = self.data[STAGE]
func toggle_visibility(node_group: Array[Node]):
	var result: bool
	for item in node_group:
		item.visible = !item.visible
		result = item.visible
	return result

func set_op_avatar():
	op_avatar.clear()
	var list = Common.current_avatar_list
	for item in list:
		op_avatar.add_item(item,list.find(item))
		op_avatar.set_item_metadata(
			list.find(item),
			Common.avatar_list[item]
			)
	op_avatar.select(-1)

func set_op_state(_index: int):
	op_state.clear()
	var state_data = op_avatar.get_selected_metadata()["states"]
	for i in range(state_data.keys().size()):
		op_state.add_item(state_data.keys()[i],i)
		if state_data.keys()[i] == "default":
			op_state.select(i)

func set_stage(flag: bool):
	if flag:
		button.text = "上场"
	else:
		button.text = "下场"
	data[STAGE] = flag

func set_text_edit():
	text_edit.set_text(line.get_text())

func self_destory():
	self.queue_free()
