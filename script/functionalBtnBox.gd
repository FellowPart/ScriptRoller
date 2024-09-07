extends MarginContainer
signal scale_change(time)
signal play
@onready var log_box = $"../LogBox"
@onready var play_btn = $SideBox/PlayBtn
@onready var speed_btn = $SideBox/SpeedBtn

var speed:float = 1.0


func auto_play(flag: bool):
	Common.is_auto = flag
	play.emit()

func set_speed(flag: bool):
	if flag:
		speed = 0.5
	else :
		speed = 1.0
	scale_change.emit(speed)


func toggle_visibility(flag: bool):
	for item in get_tree().get_nodes_in_group("cleanVision"):
		item.set_visible(flag)

func toggle_log_box():
	log_box.visible = true

func back_to_main_scene():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
