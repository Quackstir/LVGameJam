extends Area2D
class_name HitboxComponent

@export var healthComponent : HealthComponent

signal hurt(hitbox)
signal heal(hitbox)

func _ready():
	hurt.connect(takeDamage)
	heal.connect(Heal)

func takeDamage(area: int):
	print(get_parent().name + ": Damage Taken " + str(area))
	healthComponent._take_damage(area)
	
func Heal(area: int):
	print(get_parent().name + ": heal Taken " + str(area))
	healthComponent._heal(area)
	
