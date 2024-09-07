extends PanelContainer
@onready var option_button = $MarginContainer/VBoxContainer/OptionButton
@onready var delete_button = $MarginContainer/DeleteButton

var data: Dictionary
var type: String = "BackgroundSetter"
var background_list: Dictionary = Common.background_list

func _ready():
	option_button_setter()

func option_button_setter():
	option_button.clear()
	for i in range(background_list.keys().size()):
		option_button.add_item(background_list.keys()[i],i)
		option_button.set_item_metadata(i,background_list[background_list.keys()[i]])
	set_data(option_button.selected)

func set_data(_index: int):
	data["TYPE"] = type
	data["action"] = {
		"background_name":option_button.get_item_text(option_button.selected)
	}
	pass

func get_data()-> Dictionary:
	return data

func set_op_button(_data):
	for i in range(option_button.item_count):
		if _data == option_button.get_item_text(i):
			option_button.select(i)
			set_data(i)

func self_destory():
	self.queue_free()
