extends Control

@onready var texture_rect: TextureRect = $CanvasLayer/TextureRect
@onready var video_stream_player: VideoStreamPlayer = $CanvasLayer/VideoStreamPlayer

func _ready() -> void:
	_fmod_logo()

func _fmod_logo() -> void:
	var tween:Tween = self.create_tween()
	tween.tween_property(texture_rect, "modulate:a", 1,2)
	tween.tween_property(texture_rect, "modulate:a", 0,2).set_delay(2)
	tween.tween_callback(video_stream_player.play)

func _input(event:InputEvent):
		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("Select"):
			get_tree().change_scene_to_file("res://Levels/menu.tscn")


func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_file("res://Levels/menu.tscn")
