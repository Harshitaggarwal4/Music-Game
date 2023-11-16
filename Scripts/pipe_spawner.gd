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
var black = load("res://Assets/blackImage.jpg")
var yellow = load("res://Assets/YellowishWhite.png")
var white_swaras = ['g', 'd', 'n']

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

func set_textures(pipe, textures):
	var collision_shapes = [
		pipe.get_node("TopPipe/CollisionShape2D"),
		pipe.get_node("BottomPipe/CollisionShape2D")
	]
	var sprites = [
		pipe.get_node("TopPipe/CollisionShape2D/Pipe-green"),
		pipe.get_node("BottomPipe/CollisionShape2D/Pipe-green2")
	]
	for i in range(2):
		var collision_extents = collision_shapes[i].shape.extents
		sprites[i].texture = textures[i]
		# Calculate the scale factors to resize the sprite to match the collision shape's size
		var texture_size = sprites[i].texture.get_size()
		sprites[i].scale = Vector2(
			collision_extents.x * 2.0 / texture_size.x,  # Scale factor for width
			collision_extents.y * 2.0 / texture_size.y   # Scale factor for height
		)

func decorate_pipe(pipe, swara1, swara2):
	var labels=[]
	var textures=[]
	for label_data in [[swara1,Vector2(0,-100)], [swara2,Vector2(0,350)]]:
		var label = Label.new()
		label.text = label_data[0]
		label.set_position(label_data[1])
		if label.text in white_swaras:
			label.modulate = Color.WHITE
			textures.append(black)
		else:
			label.modulate = Color.BLACK
			textures.append(yellow)
		# label.add_theme_font_override("font",load("res://Assets/font/FlappyBird.ttf"))
		label.add_theme_font_size_override("font", 100)
		pipe.add_child(label)
		labels.append(label)

	set_textures(pipe, textures)

func spawn_pipe():
	# spawn_pipe_old()
	# return
	if number_of_swaras_done == length:
		return

	var correct_swara = swaras[number_of_swaras_done]

	# choose two random swaras other than the correct swara
	var swara1 = correct_swara
	var swara2 = correct_swara

	while swara1 == correct_swara:
		swara1 = swara[randi_range(0, swara.size() - 1)]
	
	while swara2 == correct_swara or swara2 == swara1:
		swara2 = swara[randi_range(0, swara.size() - 1)]
	
	# choose a random pipe
	var choosen_pipe = randi_range(1, 4)

	# what is this?
	if first == false:
		first = true
		choosen_pipe = 1

	# instantiate the pipe
	var pipe
	if choosen_pipe == 1 or choosen_pipe == 2:
		pipe = pipe_pair_scene1.instantiate() as PipePair1
		decorate_pipe(pipe, swara1, swara2)
	elif choosen_pipe == 3:
		pipe = pipe_pair_scene2.instantiate() as PipePair2
		decorate_pipe(pipe, correct_swara+"this", swara2)
		pipe.swara_name = correct_swara
		number_of_swaras_done += 1
	elif choosen_pipe == 4:
		pipe = pipe_pair_scene3.instantiate() as PipePair3
		decorate_pipe(pipe, swara1, correct_swara+"this")
		pipe.swara_name = correct_swara
		number_of_swaras_done += 1
	
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
