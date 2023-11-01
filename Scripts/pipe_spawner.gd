extends Node

class_name PipeSpawner

signal bird_crashed
signal point_scored
signal check_if_point_increasedd
signal game_won

var pipe_pair_scene1 = preload("res://Scene/pipe_pair1.tscn")
var pipe_pair_scene2 = preload("res://Scene/pipe_pair2.tscn")
var pipe_pair_scene3 = preload("res://Scene/pipe_pair3.tscn")

var swaras = ['p', 'n', 'p', 'n', 'p', 'm', 'm', 'p', 'm', 'p', 'm', 'g']
var swara = ['s', 'r', 'g', 'm', 'p', 'd', 'n']
var number_of_swaras_done = 0
var number_of_swaras_pressed = 0
var length = swaras.size()

@export var pipe_speed = -150
@export var pipe_speed_y = 20
@onready var spawn_timer = $SpawnTimer

func _ready():
	var my_name_list = MainMenu.text_list
	var my_swara_list = MainMenu.swaras_list
	swaras = my_swara_list
	length = swaras.size()
	spawn_timer.timeout.connect(spawn_pipe)
	
func start_spawning_pipes():
	spawn_timer.start()

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
		var pipe
		if choosen_pipe == 1 or choosen_pipe == 2:
			pipe = pipe1
			
			var label_top = Label.new()
			label_top.text = swara[choosen_number_1]
			label_top.set_position(Vector2(0,-170))
			pipe.add_child(label_top)
			
			var label_bottom = Label.new()
			label_bottom.text = swara[choosen_number_2]
			label_bottom.set_position(Vector2(0,240))
			pipe.add_child(label_bottom)
		if choosen_pipe == 3:
			pipe = pipe2

			var label_top = Label.new()
			label_top.text = swaras[number_of_swaras_done] + "fuck"
			number_of_swaras_done += 1
			label_top.set_position(Vector2(0,-170))
			pipe.add_child(label_top)
			
			var label_bottom = Label.new()
			label_bottom.text = swara[choosen_number_1]
			label_bottom.set_position(Vector2(0,240))
			pipe.add_child(label_bottom)
		if choosen_pipe == 4:
			pipe = pipe3
			
			var label_top = Label.new()
			label_top.text = swara[choosen_number_1]
			label_top.set_position(Vector2(0,-170))
			pipe.add_child(label_top)
			
			var label_bottom = Label.new()
			label_bottom.text = swaras[number_of_swaras_done] + "fuck"
			number_of_swaras_done += 1		
			label_bottom.set_position(Vector2(0,240))
			pipe.add_child(label_bottom)

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
	bird_crashed.emit()
	stop()
	
func on_bird_entered_correct():
	point_scored.emit()
	if swaras[number_of_swaras_pressed] == ',':
		play_swara(swaras[number_of_swaras_pressed - 1])
	else:
		play_swara(swaras[number_of_swaras_pressed])
	number_of_swaras_pressed += 1
	if (number_of_swaras_pressed == length):
		game_won.emit()

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
