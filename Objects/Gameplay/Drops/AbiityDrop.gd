class_name AbilityDrop
extends Area2D
# Export the damage amount this hitbox deals
@export var currentAbility:AbilityResource

# Create a signal for when the hitbox hits a hurtbox
signal hit_hurtbox(hurtbox)

func _ready():
	# Connect on area entered to our hurtbox entered function
	print("HEALTH DROPPED")

func _on_area_entered(area):
	#print("AbilityDrop" + str(area.get_parent()))
	if not area.get_parent() is Player: return
	var player:Player = area.get_parent()
	print("Ability Drop")
	
	if !player.checkAbilityOccupied(currentAbility):
		area.get_parent().addAbility(currentAbility)
		queue_free()
