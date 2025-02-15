extends Control

func _on_play_pressed_button() -> void:
	get_tree().change_scene_to_file("res://Levels/Level.tscn")


func _on_credits_pressed_button() -> void:
	get_tree().change_scene_to_file("res://Levels/CreditsMenu.tscn")


func _on_quit_pressed_button() -> void:
	get_tree().quit()
