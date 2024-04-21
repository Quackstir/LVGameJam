extends Node2D

@onready var animation_player = $AnimationPlayer

func _on_timer_timeout():
	animation_player.play("Explosion")


func _on_audio_stream_player_2d_finished():
	queue_free()
