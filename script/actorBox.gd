extends Control


var actor_scene = preload("res://scenes/actor.tscn")
var off_stage_list: Array
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_current(_name: String):
	var children = get_children()
	for child in children:
		child.toggle_current(true) if child.name == _name else child.toggle_current(false)

#func set_data(data: Dictionary):
	#add_actor(data)

func add_actor(line: Dictionary):
	match line["TYPE"]:
		"SingleLine":
			child_clear_by_list()
			var _name = line["action"]["avatar"]
			if !has_child(_name):
				if Common.avatar_list.has(_name):
					#set_current(_name)
					var data = Common.avatar_list[_name]
					if data["states"].has(line["action"]["state"]):
						var path = data["folder_path"]+"/states/"+line["action"]["state"]+".png"
						var actor = actor_scene.instantiate()
						actor.set_image(path)
						actor.name = _name
						self.add_child(actor)
						child_node_sort()
			else:
				set_current(_name)
			#下场数组
			if !line["action"]["stage"]:
				off_stage_list.append(_name)
		"BackgroundSetter":
			child_clear()

func has_child(_name):
	for child in get_children():
		if child.name == _name:
			return true
	return false

func child_node_sort():
	#排列子节点，尽量靠近中心
	#不能超出节点范围
	#控制间距，标准为0，
	var spacing: float = 0
	var parent = self.get_rect().size.x
	var totalX: float = 0
	var pivotX = 0
	for child in self.get_children():
		totalX += child.get_rect().size.x
	while totalX - (get_child_count()-1) * spacing > parent:
		spacing += 1
	if get_child_count() % 2 != 0:
		parent = self.get_rect().size.x/2
		var flag: bool = true
		for child in get_children():
			if flag:
				child.position.x = parent - pivotX - child.size.x/2
				pivotX = pivotX + child.size.x - spacing
			else:
				child.position.x = parent + pivotX - child.size.x/2
			flag = !flag
	else:
		parent = self.get_rect().size.x/2 - get_child(0).size.x/2
		var flag: bool = true
		for child in get_children():
			if flag:
				child.position.x = parent - pivotX - child.size.x/2 + spacing
				pivotX += child.size.x - spacing
			else:
				child.position.x = parent + pivotX - child.size.x/2
			flag = !flag

func child_clear_by_list():
	for item in off_stage_list:
		child_clear_by_name(item)
	off_stage_list.clear()

func child_clear_by_name(_name: String):
	for child in get_children():
		if child.name == _name:
			child.exit_effect()

func child_clear():
	for child in get_children():
		child.exit_effect()
