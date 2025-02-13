extends Control
@onready var hover_sound = %HoverSound
#@onready var options_button = $MarginContainer/HBoxContainer/VBoxContainer/Options_button as Button
#@onready var options_menu = $"CanvasLayer/Menu/MarginContainer/HBoxContainer/Options Menu"
@onready var play_game: Button = $"CanvasLayer/Menu/MarginContainer/VBoxContainer/PlaygameContainer/Play Game"

func _ready() -> void:
	play_game.grab_focus()

func _on_play_game_button_down():
	get_tree().change_scene_to_file("res://Levels/Level.tscn")

func _on_quit_game_button_down():
	get_tree().quit()


func _on_play_game_focus_entered():
	hover_sound.play()


func _on_quit_game_focus_entered():
	hover_sound.play()


func _on_play_game_mouse_entered():
	hover_sound.play()


func _on_quit_game_mouse_entered():
	hover_sound.play()
