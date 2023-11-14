extends Node

class_name PipeSpawner

signal bird_crashed
signal point_scored
signal check_if_point_increasedd
signal game_won

@onready var bird = get_node("../Bird") as Bird

var pipe_pair_scene1 = preload("res://Scene/pipe_pair1.tscn")
var pipe_pair_scene2 = preload("res://Scene/pipe_pair2.tscn")
var pipe_pair_scene3 = preload("res://Scene/pipe_pair3.tscn")

var swaras = ['p', 'n', 'p', 'n', 'p', 'm', 'm', 'p', 'm', 'p', 'm', 'g']
var swara = ['s', 'r', 'g', 'm', 'p', 'd', 'n']
var number_of_swaras_done = 0
var number_of_swaras_pressed = 0
var length = swaras.size()
var first = false

@export var pipe_speed = -250 - (MainMenu.Level-1)*25
@export var pipe_speed_y = 5 + (MainMenu.Level-1)*5
@onready var spawn_timer = $SpawnTimer

func _ready():
#	print("WOW")
	var my_name_list = MainMenu.text_list
	var my_swara_list = MainMenu.swaras_list
	swaras = my_swara_list
	length = swaras.size()
	spawn_timer.timeout.connect(spawn_pipe)
	
func start_spawning_pipes():
	spawn_timer.start()
	
	
	
func setTexture_Top(pipe,label_top,black,yellow):
	var collision_shape = pipe.get_node("TopPipe/CollisionShape2D")
	var rectangle_shape = collision_shape.shape
	var collision_extents = rectangle_shape.extents


	var sprite = pipe.get_node("TopPipe/CollisionShape2D/Pipe-green")
	if(label_top.text == "s" or label_top.text == "r" or  label_top.text == "m" or  label_top.text == "p"):
		sprite.texture = black 
	else:
		sprite.texture = yellow

	# Calculate the scale factors to resize the sprite to match the collision shape's size
	var texture_size = sprite.texture.get_size()
	sprite.scale = Vector2(
		collision_extents.x * 2.0 / texture_size.x,  # Scale factor for width
		collision_extents.y * 2.0 / texture_size.y   # Scale factor for height
	)



func setTexture_Buttom(pipe,label_top,black,yellow):
	var collision_shape = pipe.get_node("BottomPipe/CollisionShape2D")
	var rectangle_shape = collision_shape.shape
	var collision_extents = rectangle_shape.extents
	
	var sprite = pipe.get_node("BottomPipe/CollisionShape2D/Pipe-green2")
	
	if(label_top.text == "s" or label_top.text == "r" or  label_top.text == "m" or  label_top.text == "p"):
		sprite.texture = black 
	else:
		sprite.texture = yellow
		
	# Calculate the scale factors to resize the sprite to match the collision shape's size
	var texture_size = sprite.texture.get_size()
	sprite.scale = Vector2(
		collision_extents.x * 2.0 / texture_size.x,  # Scale factor for width
		collision_extents.y * 2.0 / texture_size.y   # Scale factor for height
	)




func spawn_pipe():
	if (number_of_swaras_done != length):
		var pipe1 = pipe_pair_scene1.instantiate() as PipePair1
		var pipe2 = pipe_pair_scene2.instantiate() as PipePair2
		var pipe3 = pipe_pair_scene3.instantiate() as PipePair3
		var choosen_number_1 = randi_range(0, 6)
		while swara[choosen_number_1] == swaras[number_of_swaras_done]:
			choosen_number_1 = randi_range(0, 6)
		var choosen_number_2 = randi_range(0, 6)
		if swara[choosen_number_2] == swaras[number_of_swaras_done]:
			choosen_number_2 = choosen_number_1
		while choosen_number_1 == choosen_number_2:
			choosen_number_2 = randi_range(0, 6)
			if swara[choosen_number_2] == swaras[number_of_swaras_done]:
				choosen_number_2 = choosen_number_1
		var choosen_pipe = randi_range(1, 4)
		var black = load("res://Assets/blackImage.jpg")
		var yellow = load("res://Assets/YellowishWhite.png")
		var pipe
		if first == false:
			first = true
			choosen_pipe = 1
		if choosen_pipe == 1 or choosen_pipe == 2:
			pipe = pipe1
			
			var label_top = Label.new()
			label_top.text = swara[choosen_number_1]
			label_top.set_position(Vector2(0,-100))
#			print("YO")
#			print(label_top.text)
			label_top.modulate = Color.BLACK
			if(label_top.text == "g" or label_top.text == "d" or  label_top.text == "n"):
				label_top.modulate = Color.BLACK
			else:
				label_top.modulate = Color.WHITE
			label_top.add_theme_font_override("font",load("res://Assets/font/FlappyBird.ttf"))
			pipe.add_child(label_top)
			
			
			setTexture_Top(pipe,label_top,black,yellow)
			
			
			
			
			var label_bottom = Label.new()
			label_bottom.text = swara[choosen_number_2]
			label_bottom.set_position(Vector2(0,350))
			if(label_bottom.text == "g" or label_bottom.text == "d" or  label_bottom.text == "n"):
				label_bottom.modulate = Color.BLACK
			else:
				label_bottom.modulate = Color.WHITE
			label_bottom.add_theme_font_override("font",load("res://Assets/font/FlappyBird.ttf"))
			label_bottom.add_theme_font_size_override("font", 100)	
			pipe.add_child(label_bottom)
			
			setTexture_Buttom(pipe,label_bottom,black,yellow)
			
			
#---------------------------------------------------------------
		if choosen_pipe == 3:
			pipe = pipe2
			pipe.swara_name = swaras[number_of_swaras_done]

			var label_top = Label.new()
			label_top.text = swaras[number_of_swaras_done] + "this"
			number_of_swaras_done += 1
			label_top.set_position(Vector2(0,-100))
			if(label_top.text == "g" or label_top.text == "d" or  label_top.text == "n"):
				label_top.modulate = Color.BLACK
			else:
				label_top.modulate = Color.WHITE
			label_top.add_theme_font_override("font",load("res://Assets/font/FlappyBird.ttf"))
			label_top.add_theme_font_size_override("font", 100)
			pipe.add_child(label_top)
			
			setTexture_Top(pipe,label_top,black,yellow)
			
			
			
			
			var label_bottom = Label.new()
			label_bottom.text = swara[choosen_number_1]
			label_bottom.set_position(Vector2(0,350))
			if(label_bottom.text == "g" or label_bottom.text == "d" or  label_bottom.text == "n"):
				label_bottom.modulate = Color.BLACK
			else:
				label_bottom.modulate = Color.WHITE
			label_bottom.add_theme_font_override("font",load("res://Assets/font/FlappyBird.ttf"))
			label_bottom.add_theme_font_size_override("font", 100)
			pipe.add_child(label_bottom)
			
			setTexture_Buttom(pipe,label_bottom,black,yellow)
			

##---------------------------------------------------------------
			
		if choosen_pipe == 4:
			pipe = pipe3
			pipe.swara_name = swaras[number_of_swaras_done]
			
			var label_top = Label.new()
			label_top.text = swara[choosen_number_1]
			label_top.set_position(Vector2(0,-100))
			if(label_top.text == "g" or label_top.text == "d" or  label_top.text == "n"):
				label_top.modulate = Color.BLACK
			else:
				label_top.modulate = Color.WHITE
			label_top.add_theme_font_override("font",load("res://Assets/font/FlappyBird.ttf"))
			label_top.add_theme_font_size_override("font", 100)
			pipe.add_child(label_top)
			
			setTexture_Top(pipe,label_top,black,yellow)
			
			

			
			
			var label_bottom = Label.new()
			label_bottom.text = swaras[number_of_swaras_done] + "this"
			number_of_swaras_done += 1		
			label_bottom.set_position(Vector2(0,350))
			if(label_bottom.text == "g" or label_bottom.text == "d" or  label_bottom.text == "n"):
				label_bottom.modulate = Color.BLACK
			else:
				label_bottom.modulate = Color.WHITE
			label_bottom.add_theme_font_override("font",load("res://Assets/font/FlappyBird.ttf"))
			label_bottom.add_theme_font_size_override("font", 100)	
			pipe.add_child(label_bottom)
			
			setTexture_Buttom(pipe,label_bottom,black,yellow)



			
			

		add_child(pipe)
		
		var viewport_rect = get_viewport().get_camera_2d().get_viewport_rect()
		var half_height = viewport_rect.size.y / 2
		pipe.position.x = viewport_rect.end.x
		pipe.position.y = viewport_rect.size.y*0.35 - half_height
		
		pipe.bird_entered_incorrect.connect(on_bird_entered_incorrect)
		pipe.bird_entered_correct.connect(on_bird_entered_correct)
		pipe.check_if_point_increased.connect(check_if_point_increased)
		pipe.set_speed(pipe_speed, pipe_speed_y)
	
	
func on_bird_entered_incorrect():
	bird.upward_stop()	
	bird_crashed.emit()
	stop()
	
func on_bird_entered_correct(swara_name):
	if swara_name == swaras[number_of_swaras_pressed]:
		bird.upward_stop()
		point_scored.emit()
		if swaras[number_of_swaras_pressed] == ',':
			play_swara(swaras[number_of_swaras_pressed - 1])
		else:
			play_swara(swaras[number_of_swaras_pressed])
		number_of_swaras_pressed += 1
		if (number_of_swaras_pressed == length):
	#		print("hihi")
			game_won.emit()
	else:
		bird.upward_stop()

func stop():
	spawn_timer.stop()
	for pipe in get_children().filter(func (child): return child is PipePair1):
		(pipe as PipePair1).speed = 0
		(pipe as PipePair1).speed_y = 0
	for pipe in get_children().filter(func (child): return child is PipePair2):
		(pipe as PipePair2).speed = 0
		(pipe as PipePair2).speed_y = 0
	for pipe in get_children().filter(func (child): return child is PipePair3):
		(pipe as PipePair3).speed = 0
		(pipe as PipePair3).speed_y = 0

func check_if_point_increased():
	check_if_point_increasedd.emit()
	
func play_swara(swara):
	var notes = "sRrGgmMpDdNn"
	var octave = 4
	var notenum = notes.find(swara) + octave * 12
	var audio := AudioStreamPlayer.new()
	add_child(audio)
	var note_id: String = str(notenum)
	audio.stream = load("res://Assets/piano/"+note_id+".mp3")
	audio.play()
