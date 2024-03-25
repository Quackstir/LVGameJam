extends Area2D
class_name HitboxComponent

@export var healthComponent : HealthComponent

signal hurt(hitbox)

func _ready():
	hurt.connect(takeDamage)

func takeDamage(area: int):
	print(get_parent().name + ": Damage Taken " + str(area))
	healthComponent._take_damage(area)
	
