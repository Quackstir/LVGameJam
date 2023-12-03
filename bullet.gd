extends RigidBody2D

@onready var damage_box_component: DamageBoxComponent = $DamageBoxComponent as DamageBoxComponent

#func _ready():
#	damage_box_component.hit_hurtbox(queue_free)


func _on_damage_box_component_area_entered(area):
	queue_free()
