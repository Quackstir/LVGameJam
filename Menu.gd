extends Control

func _on_player_pressed():
	get_tree().change_scene_to_file("res://Level.tscn")


func _on_options_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()
