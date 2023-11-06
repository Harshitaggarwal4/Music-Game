extends CanvasLayer

class_name UI

@onready var points_label = $MarginContainer/PointsLabel
@onready var resume_game_button = $MarginContainer/GameOverBox/Panel/MarginContainer/RestartButton
@onready var game_over_box = $MarginContainer/GameOverBox

func _ready():
	points_label.text = "%d" % 0
	
func update_points(points: int):
		points_label.text = "%d" % points

func on_game_over():
	game_over_box.visible = true
	resume_game_button.grab_focus()

func on_game_win():
	game_over_box.visible = true

func _on_restart_button_pressed():
	get_tree().reload_current_scene()


func _on_button_pressed():
	PauseMenu.open_pause_menu()
	pass # Replace with function body.
