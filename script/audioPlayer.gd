extends Node
signal music_switch

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_data(data: Dictionary):
	if data["TYPE"] == "MusicSetter":
		audio_setter(data["action"]["music_name"])
	pass

func audio_setter(_name: String):
	var player = AudioStreamPlayer.new()
	var path:String = Common.music_list[_name]
	player.stream = AudioStreamOggVorbis.load_from_file(path)
	player.autoplay = true
	for child in get_children():
		child.queue_free()
	self.add_child(player)
	player.finished.connect(auto_loop.bind(player))
	music_switch.emit()

func auto_loop(node:AudioStreamPlayer):
	await get_tree().create_timer(3).timeout
	node.playing = true
