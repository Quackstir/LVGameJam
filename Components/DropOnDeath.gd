class_name DropOnDeath
extends Node2D

@export var dropScene:Array[PackedScene]
@onready var health_component = $"../HealthComponent"
@onready var enemy = $".."

signal hurt(hitbox)

func _ready():
	health_component.onDeath.connect(drop)

func drop():
	for drops in dropScene:
		dropstuff(drops)
	get_parent().queue_free()

func dropstuff(sceneToDrop:PackedScene):
	var drop_instance = sceneToDrop.instantiate()
	get_tree().current_scene.add_child(drop_instance)
	drop_instance.global_position = global_position
