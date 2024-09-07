extends Node

const AVATARS_PATH = "user://ScriptRoller/pic/avatars/"
const BACKGROUND_PATH = "user://res/pic/backgrounds/"
const MUSIC_PATH = "user://res/bgm/"

#获取全部资源
var avatar_list: Dictionary

var state_list: Dictionary

var background_list: Dictionary

var music_list: Dictionary

var script_list: Dictionary


#编辑和播放共用
var current_script: Dictionary

var current_script_name: String

var current_avatar_list: Array

#自动播放
var is_auto: bool = false

#文件处理
var file = AutoFileAccess.new()

func _ready():
	refresh_list()
	pass

func load_script():
	if script_list.has(current_script_name):
		current_script = file.load_script(current_script_name)
		current_avatar_list = current_script["avatar_list"].keys()
		return true
	else:
		return false

func delete_script(file_name: String):
	file.delete_script(file_name)
	script_list = file.get_script_list()

func refresh_list():
	avatar_list = file.get_avatars_list()
	background_list = file.get_background_files()
	music_list = file.get_music_files()
	file.read_filepath()
	script_list = file.get_script_list()
