extends PanelContainer
@onready var script_name = $MarginContainer/HBoxContainer/Label

func mouse_enter():
	set_self_modulate(Color.WEB_GRAY)
	pass

func mouse_exit():
	set_self_modulate(Color.WHITE)
	pass

func self_click(event):
	if event is InputEventMouseButton\
	and event.button_index == MOUSE_BUTTON_LEFT\
	and event.is_pressed()\
	and event.double_click:
		open_script()

func set_data(_script_name:String):
	self.script_name.text = _script_name

func open_script():
	Common.current_script_name = script_name.text
	get_tree().change_scene_to_file("res://scenes/editScript.tscn")

func self_destory():
	Common.delete_script(script_name.text)
	self.queue_free()
