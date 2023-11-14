extends CanvasLayer

class_name UI

@onready var points_label = $MarginContainer/PointsLabel
@onready var resume_game_button = $MarginContainer/GameOverBox/Panel/MarginContainer/RestartButton
@onready var floatingName = $Label
@onready var floatingSwara = $Label2
@onready var game_over_box = $MarginContainer/GameOverBox
@onready var game_over_box2 = $MarginContainer/GameOverBox2

@onready var PanelPause : Panel = $%Panel
@onready var contentPause : VBoxContainer = $%Content


func _ready():
	PanelPause.hide()
	contentPause.hide()
	points_label.text = "%d" % 0
	floatingName.text = " ".join(MainMenu.text_list)
	floatingSwara.text = " ".join(MainMenu.swaras_list)

func update_points(points: int):
		points_label.text = "%d" % points

func on_game_over():
	game_over_box.visible = true
	resume_game_button.grab_focus()

func on_game_win():
	MainMenu.Level += 1
	$MarginContainer/GameOverBox2/Panel/MarginContainer/Button2.text = "Level : " + str(MainMenu.Level) 
	game_over_box2.visible = true


func _on_restart_button_pressed():
	get_tree().reload_current_scene()


func _on_button_pressed():
	if get_tree().paused:
		PanelPause.hide()
		contentPause.hide()
		get_tree().paused = false
	PanelPause.show()
	contentPause.show()
	get_tree().paused = true
#	PauseMenu.open_pause_menu()
	pass # Replace with function body.
	
func _input(event):
	if event.as_text() == "Enter":
		_on_button_pressed()


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://addons/EasyMenus/Scenes/NamePage.tscn")
	pass # Replace with function body.



func _on_quit_button_pressed():
	get_tree().paused = false
	get_tree().quit()
	pass # Replace with function body.
 

func _on_back_to_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://addons/EasyMenus/Nodes/menu_template_manager.tscn")
	pass # Replace with function body.


func _on_resume_game_button_pressed():
	get_tree().paused = false
	PanelPause.hide()
	contentPause.hide()
	pass # Replace with function body.


func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://addons/EasyMenus/Scenes/options_menu.tscn")
	pass # Replace with function body.

func _on_button_3_pressed():
	get_tree().quit()
