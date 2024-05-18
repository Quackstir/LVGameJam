extends Ability
class_name BarrageAbility

@export var missle: PackedScene
@export var missle_speed: float = 1000.0

func _activate_ability():
	super()
	fireBullet(player.up)
	fireBullet(player.down)
	fireBullet(player.left)
	fireBullet(player.right)
	player.rockets_icon.visible = false
	
func fireBullet(direction):
	var missle_instance = missle.instantiate()
	#audio_stream_player_2d.play()
	missle_instance.global_position = direction.global_position
	missle_instance.rotation_degrees = direction.rotation_degrees
	missle_instance.apply_central_impulse(Vector2(missle_speed,0).rotated(direction.global_rotation))
	get_tree().get_root().add_child(missle_instance)
