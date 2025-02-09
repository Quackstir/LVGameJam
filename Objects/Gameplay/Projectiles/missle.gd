extends RigidBody2D

@onready var damage_box_component: DamageBoxComponent = $DamageBoxComponent as DamageBoxComponent
@export var explosion:PackedScene
#func _ready():
#	damage_box_component.hit_hurtbox(queue_free)


func _on_damage_box_component_area_entered(area):
	var explosion_instance = explosion.instantiate()
	explosion_instance.global_position = global_position
	get_tree().current_scene.add_child(explosion_instance)
	queue_free()
