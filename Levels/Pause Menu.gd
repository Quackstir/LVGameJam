extends Control
  
@onready var pause_menu = $"CanvasLayer/Pause Menu Panel"
@onready var resume_game: Button = $"CanvasLayer/Pause Menu Panel/MarginContainer/VBoxContainer/HBoxContainer3/Resume Game"

var paused = false:
	set(newValue):
		paused = newValue
		if paused:
			pause_menu.hide()
			Engine.time_scale = 1
		else:
			pause_menu.show()
			resume_game.grab_focus()
			Engine.time_scale = 0


func _on_resume_game_button_down():
	pauseMenu()

func _ready():
	pause_menu.hide()

func pauseMenu():
	paused = !paused

func _on_button_pressed():
	get_tree().quit()

func _on_resume_game_pressed():
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://Levels/Level.tscn")
	
