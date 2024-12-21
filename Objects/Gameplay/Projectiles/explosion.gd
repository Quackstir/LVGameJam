extends Node2D

@onready var collision_shape_2d = $DamageBoxComponent/CollisionShape2D
@onready var animation_player = $AnimationPlayer

# should be the maximum distance an explosion could be assuming the numbers I was given was correct
const MAXDIST = sqrt((2845*2845)+(1773*1773))
# event 
@export var event: EventAsset
var instance: EventInstance

func _enter_tree() -> void:
	PlayFMODSound()

func _on_timer_timeout():
	collision_shape_2d.disabled = true
	animation_player.play("Explosion")

# Plays the explosion sound, adapting the parameters to where the player is at.
func PlayFMODSound():
	# gets the player position to position sound properly
	var player_position = GM.gameManager.player.position
	# gets distance to player compared to maximum distance it could be
	var dist = (position.distance_to(player_position) / MAXDIST)
	# gets loudness by having less distance equal higher volume
	var eq = 1.0 - dist
	# gets which side it should be on by having distance + direction determine it
	var pan = eq / 2.0
	if(player_position.x < position.x):
		pan = 1.0 - pan;
	# Creates the instance, sets the parameters for it, and then starts it.
	instance = FMODRuntime.create_instance(event)
	instance.start()
	instance.set_parameter_by_name("EQ for Ant", eq, false)
	instance.set_parameter_by_name("Panning for Enemy", pan, false)
	instance.release()
	
