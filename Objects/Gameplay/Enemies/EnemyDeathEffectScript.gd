extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var point_light_2d: PointLight2D = $PointLight2D

func _ready() -> void:
	var tween = point_light_2d.create_tween().set_loops()
	tween.tween_property(point_light_2d,"energy",1, 0.5)

func _on_timer_timeout():
	animation_player.play("Explosion")

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
