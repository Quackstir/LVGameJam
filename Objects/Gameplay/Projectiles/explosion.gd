extends Node2D

@onready var collision_shape_2d = $DamageBoxComponent/CollisionShape2D
@onready var animation_player = $AnimationPlayer

func _on_timer_timeout():
	collision_shape_2d.disabled = true
	animation_player.play("Explosion")


func _on_audio_stream_player_2d_finished():
	queue_free()
