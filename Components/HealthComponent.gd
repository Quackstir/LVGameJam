class_name HealthComponent
extends Node2D


@export var Max_Health: int = 1
@onready var Curr_Health: int = Max_Health: set = _set_health, get = _get_health

signal Health_Change(newHealth:int)
signal onDeath

func _take_damage(damage):
	_set_health(Curr_Health - damage)
	
func _heal(healAmount):
	_set_health(Curr_Health + healAmount)

func _set_health(new_value : int):
	Curr_Health = new_value
	print("New Health: " + str(Curr_Health))
	emit_signal("Health_Change", new_value)
	
	if Curr_Health > Max_Health: Curr_Health = Max_Health
	
	if Curr_Health <= 0:
		Death()
	
func _get_health():
	return Curr_Health
	
func Death():
	emit_signal("onDeath")
