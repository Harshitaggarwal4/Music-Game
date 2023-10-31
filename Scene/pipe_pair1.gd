extends Node2D

class_name PipePair1

var speed = 0  # The speed at which the pipes move

signal bird_entered_correct
signal bird_entered_incorrect
signal check_if_point_increased

func set_speed(new_speed):
	speed = new_speed
	
func _process(delta):
	position.x += speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	bird_entered_incorrect.emit()
