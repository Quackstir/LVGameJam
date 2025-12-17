class_name KnockBack
extends Area2D

@onready var knock_back_collision: CollisionShape2D = $KnockBackCollision
var EnemiesWithin:Array[Area2D]

func _enable_knockback() -> void:
	visible = true
	_knockback_enemies()
	
func _disable_knockback() -> void:
	visible = false

func _on_area_entered(area) -> void:
	EnemiesWithin.append(area)

func _on_area_exited(area) -> void:
	EnemiesWithin.erase(area)
	
func _knockback_enemies() -> void:
	for enemy in EnemiesWithin:
		var knockbackDirection = enemy.get_parent().position - get_parent().position
	#area.parent.velocity = knockbackDirection
		enemy.get_parent().velocity = knockbackDirection * 2
		enemy.get_parent().stunEnemy()
