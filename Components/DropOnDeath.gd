class_name DropOnDeath
extends Node2D

@export var dropScene:PackedScene
@onready var health_component = $"../HealthComponent"
@onready var enemy = $".."

signal hurt(hitbox)

func _ready():
	health_component.onDeath.connect(drop)

func drop():
	var drop_instance = dropScene.instantiate()
	get_tree().get_root().add_child(drop_instance)
	drop_instance.global_position = global_position
	get_parent().queue_free()
