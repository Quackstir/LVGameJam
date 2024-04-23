extends Panel

func _on_Resume_Game_button_down():
	get_tree().change_scene_to_file("res://Level.tscn")

func _on_Quit_Game_button_down():
	get_tree().quit()
