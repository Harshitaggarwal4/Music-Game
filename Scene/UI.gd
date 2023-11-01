extends CanvasLayer

class_name UI

@onready var points_label = $MarginContainer/PointsLabel
@onready var game_over_box = $MarginContainer/GameOverBox

func _ready():
	points_label.text = "%d" % 0
	
func update_points(points: int):
		points_label.text = "%d" % points

func on_game_over():
	game_over_box.visible = true

func on_game_win():
	game_over_box.visible = true

func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://addons/EasyMenus/Scenes/main_menu.tscn")


func _on_button_pressed():
	PauseMenu.open_pause_menu()
	pass # Replace with function body.
