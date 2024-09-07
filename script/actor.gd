extends TextureRect
var timer
var strength: float = 5
	
# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = Color("ffffff00")
	position.y += get_parent_area_size().y - self.size.y
	show_up_effect()
	#await get_tree().create_timer(5).timeout
	#exit_effect()
	pass # Replace with function body.

#func show_up():
	#var tween = create_tween()
	##tween.tween_property(self,"modulate",Color.BLACK,0.5)
	#tween.tween_property(self,"modulate",Color.WHITE,0.4)

func set_image(path):
	set_texture(
		ImageTexture.create_from_image(
			Image.load_from_file(path)
		)
	)

func switch_image(path):
	#var tween = create_tween()
	#tween.tween_property(self,"modulate",Color("ffffff00"),0.1)
	set_texture(
		ImageTexture.create_from_image(
			Image.load_from_file(path)
		)
	)

func toggle_current(flag: bool):
	var tween = create_tween()
	if flag:
		z_index = 1
		tween.tween_property(self,"modulate",Color.WHITE,0.4)
	else:
		z_index = 0
		tween.tween_property(self,"modulate",Color("8f8f8f"),0.4)

func show_up_effect():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"modulate",Color.WHITE,0.4)

func exit_effect():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"modulate",Color("ffffff00"),0.4)
	await tween.finished
	self.queue_free()

func shock_effect():
	var tween = get_tree().create_tween().set_loops(10)
	tween.tween_callback(move_pos)
	pass

func shake():
	self.position += Vector2(
		randf_range(-strength,+strength),
		randf_range(-strength,+strength),
	)
	strength = move_toward(strength,0,0.1)
	pass

func move_pos():
	print(position)
	#self.position = pos
