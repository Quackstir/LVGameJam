extends Control
  
@onready var pause_menu = $"CanvasLayer/Pause Menu Panel"
var paused = false


func _on_resume_game_button_down():
	pauseMenu()


func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	paused = !paused

func _on_button_pressed():
	get_tree().quit()

func _on_resume_game_pressed():
	get_tree().change_scene_to_file("res://Levels/Level.tscn")


