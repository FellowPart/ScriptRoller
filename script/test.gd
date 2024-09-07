extends Control
@onready var button = $Button
@onready var option_button = $OptionButton

@onready var texture_rect = $TextureRect
@onready var audio_stream_player = $AudioStreamPlayer
"res://res/pic/avatars/111辰星.png"
var array = [1,2,3,4]
var data={
	"bura": "bbb",
	"array":{"arrayaaa":"aaa"}}
# Called when the node enters the scene tree for the first time.
func _ready():
	option_button.select(2)
	var tween = create_tween()
	tween.tween_property($TextureRect,"position",Vector2(500,500),10)
	tween.tween_property($TextureRect,"position",Vector2(10,400),10)
	await tween.finished
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_stage(flag: bool):
	if flag:
		button.text = "上场"
	else:
		button.text = "下场"

func tets():
	var tween = create_tween()
	tween.tween_property(self,"modulate",Color.BLACK,0.5)
	tween.tween_property(self,"modulate",Color.WHITE,0.4)
#包含以字节为单位的音频数据。"res://res/bgm/036-Dynatron - Rise To The Stars.mp3"事先导入它。请记住，此代码段将整个文件加载到内存中，对于大文件（数百兆字节或更多）可能并不理想。

func load_ogg(path):
	return AudioStreamOggVorbis.load_from_file(path)
