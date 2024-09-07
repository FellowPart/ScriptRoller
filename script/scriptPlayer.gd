extends Control

@onready var speaker = $Base/Speaker
@onready var actor_box = $ActorBox
@onready var background_box = $Base/Stage/BackgroundBox
@onready var audio_player = $AudioPlayerBox
@onready var log_box = $Base/LogBox
@onready var functional_btn_box = $Base/FunctionalBtnBox

var current_scrpit: Dictionary
var current_line: int
var lines:Dictionary

const  BASE_TIME: float = 1.5
var time_scale: float = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	current_scrpit = Common.current_script
	lines = current_scrpit["lines"]
	current_line = 0
	pass # Replace with function body.


func set_time_scale(_scale: float):
	time_scale = _scale

#自动播放
func auto_push():
	if Common.is_auto:
		await get_tree().create_timer(BASE_TIME*time_scale).timeout
		push_to_next_line()

func mouse_input(event):
	if event is InputEventMouseButton\
	and event.button_index == MOUSE_BUTTON_LEFT\
	and event.is_pressed():
		push_to_next_line()

func push_to_next_line():
	if current_line < lines.size():
		#if !speaker.displaying:
		var line_data: Dictionary = lines["line"+str(current_line)]
		integrated_node_controller(line_data)
		current_line += 1
	else:
		Common.is_auto = false
		functional_btn_box.back_to_main_scene()

func integrated_node_controller(line_data: Dictionary):
	#设置文字
	speaker.set_data(line_data)
	#设置立绘
	actor_box.add_actor(line_data)
	#设置背景
	background_box.set_data(line_data)
	#设置音乐
	audio_player.set_data(line_data)
	#设置记录
	log_box.set_data(line_data)

func cut_scene_effect():
	var tween = create_tween()
	tween.tween_property(self,"modulate",Color.BLACK,0.5)
	tween.tween_property(self,"modulate",Color.WHITE,0.4)
