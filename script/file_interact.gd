extends GDScript
class_name AutoFileAccess

var exe_path: String = OS.get_executable_path()
var base_path: String = exe_path.get_base_dir()
var res_path: String = base_path + "/res"
var avatars_path: String = res_path + "/avatars"
var backgrounds_path: String = res_path + "/backgrounds"
var music_path: String = res_path + "/music"
var scripts_path = res_path + "/scripts"

func test():
	var dir = DirAccess.open(avatars_path)
	return dir.get_files()

func read_filepath():
	check_file(res_path)
	check_file(avatars_path)
	check_file(backgrounds_path)
	check_file(music_path)
	check_file(scripts_path)

func check_file(path: String):
	if DirAccess.dir_exists_absolute(path):
		print("path -> "+path+"    exist")
	else :
		print("path none excist,create new file folder")
		DirAccess.make_dir_absolute(path)

func save_script(data: Dictionary):
	#var json = JSON.stringify(data,"\t")
	print(data)
	var json = building_json_string(data)
	var name = "/"+data["script_name"]+".json"
	if !FileAccess.file_exists(scripts_path+name):
		print("储存"+name)
		FileAccess.open(scripts_path+name,FileAccess.WRITE).store_string(json)
	else:
		print("文件"+name+"已存在")
		print("删除原文件")
		DirAccess.remove_absolute(scripts_path+name)
		save_script(data)

func load_script(file_name: String):
	var file_path = scripts_path+"/"+file_name+".json"
	if FileAccess.file_exists(file_path):
		print("读取文件 -> "+file_name+".json")
		var file = FileAccess.open(file_path,FileAccess.READ)
		return JSON.parse_string(file.get_as_text())
	else:
		print("文件 -> "+file_name+" 不存在")
		return null

func delete_script(file_name: String):
	var file_path = scripts_path+"/"+file_name+".json"
	if FileAccess.file_exists(file_path):
		print("删除文件 -> "+ file_path)
		DirAccess.remove_absolute(file_path)

func get_avatar_states_list(path: String):
	var dir = DirAccess.open(path)
	if dir:
		return dir.get_files()

func get_avatars_list():
	var dir = DirAccess.open(avatars_path)
	var list: Dictionary = {}
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var avatar_detail: Dictionary = {}
			if dir.current_is_dir() and file_name != "." and file_name != "..":
				avatar_detail["folder_path"] = avatars_path + "/" + file_name
				avatar_detail["avatar_picture"] = "/avatar.png"
				avatar_detail["states"] \
				= get_avatar_states(avatar_detail["folder_path"])
				list[file_name] = avatar_detail
			file_name = dir.get_next()
	return list

func get_avatar_states(path: String):
	var list
	var data: Dictionary = {}
	var dir = DirAccess.open(path+"/states")
	if dir:
		list = dir.get_files()
		for item in list:
			data[item.get_basename()] = "/states/"+ item
	else:
		DirAccess.make_dir_absolute(path+"/states")
	return data

func get_background_files():
	var data: Dictionary = {}
	var dir = DirAccess.open(backgrounds_path)
	if dir:
		for i in dir.get_files():
			data[i.get_basename()] = backgrounds_path+"/"+i
	return data

func get_music_files():
	var data: Dictionary = {}
	var dir = DirAccess.open(music_path)
	if dir:
		for i in dir.get_files():
			data[i.get_basename()] = music_path+"/"+i
	return data

func get_script_list():
	var data: Dictionary = {}
	var dir = DirAccess.open(scripts_path)
	if dir:
		for i in dir.get_files():
			data[i.get_basename()] = scripts_path+"/"+i
	return data

func building_json_string(data:Dictionary):
	var keys = data.keys()
	var json_str = "{\n"
	var indent = "\t"
	for key in keys:
		var value = data[key]
		if value is String :
			json_str += indent + "\"" + key + "\":" + "\""+str(data[key]) +"\""
		else :
			json_str += indent + "\"" + key + "\":" + str(data[key])
		if key != keys[keys.size() - 1]:
			json_str += ","
		json_str += "\n"
	json_str += "}"
	return json_str
