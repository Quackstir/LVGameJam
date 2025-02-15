extends Control

func _input(event:InputEvent):
		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("Select"):
			get_tree().change_scene_to_file("res://Levels/menu.tscn")


func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_file("res://Levels/menu.tscn")
