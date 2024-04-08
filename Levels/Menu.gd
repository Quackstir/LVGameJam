extends Control
@onready var hover_sound = %HoverSound

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
