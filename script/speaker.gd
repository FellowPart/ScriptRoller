extends PanelContainer
signal line_finish

@onready var text_label = $Margin2/MarginContainer/RichTextLabel
@onready var label = $Margin2/Label
@onready var back = $Margin/Back
@onready var avatar = $Margin/Back/Avatar
@onready var line_tween = $LineTween

var delay := 0.07
#var speed
# Called when the node enters the scene tree for the first time.
func _ready():
	#set_speed(1.0)
	pass # Replace with function body.

#func set_speed(time_scale: float):
	#speed = delay * time_scale

func set_data(data: Dictionary):
	var list = Common.avatar_list
	match data["TYPE"]:
		"SingleLine":
			set_speaker_visibility(Color.WHITE)
			toggle_narrator_visibility(true)
			show_text(data["action"]["line"])
			set_label_name(data["action"]["avatar"])
			set_avatar(list[label.text]["folder_path"]+list[label.text]["avatar_picture"])
		"NarratorSetter":
			set_speaker_visibility(Color.WHITE)
			toggle_narrator_visibility(false)
			show_text(data["action"]["line"])
		"MusicSetter":
			pass
		"BackgroundSetter":
			set_speaker_visibility(Color("ffffff00"))

func toggle_narrator_visibility(flag: bool):
	for node in get_tree().get_nodes_in_group("narrator"):
		node.visible = flag

func set_speaker_visibility(color: Color):
	var tween = create_tween()
	tween.tween_property(self,"modulate",color,0.4)
	#self.visible = flag

func set_label_name(_name: String):
	label.text = _name

func set_avatar(path: String):
	avatar.set_texture(
		ImageTexture.create_from_image(
			Image.load_from_file(path)
		)
	)
	pass

func show_text(text: String):
	var line = Node.new()
	stop_text()
	#var current_text = ""
	var tween = get_tree().create_tween().bind_node(line)
	text_label.clear()
	for character in text:
		tween.tween_callback(add_char_to_label.bind(character)).set_delay(delay)
	line_tween.add_child(line)
	await tween.finished
	line_finish.emit()
	

func stop_text():
	for child in line_tween.get_children():
		child.queue_free()

func add_char_to_label(char):
	if text_label.get_v_scroll_bar().visible:
		text_label.get_v_scroll_bar().value \
		= text_label.get_v_scroll_bar().max_value\
		- text_label.get_v_scroll_bar().page
	text_label.add_text(char)
