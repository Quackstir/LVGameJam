class_name Mine
extends Node2D

@onready var weaboose_banter: Sprite2D = $WeabooseBanter
@onready var knock_back: KnockBack = $KnockBack
@onready var timer: Timer = $Timer

func _on_area_2d_area_entered(area: Area2D) -> void:
	weaboose_banter.visible = false
	knock_back._enable_knockback()
	timer.start()

func _on_timer_timeout() -> void:
	queue_free()
