extends Area2D

func _on_area_entered(area):
	var knockbackDirection = area.get_parent().position - get_parent().position
	#area.parent.velocity = knockbackDirection
	area.get_parent().velocity = knockbackDirection * 2
	area.get_parent().stunEnemy()
