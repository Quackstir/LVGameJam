extends Node2D

class_name WeaponComponent

@export var Bullet: PackedScene
@export var bullet_speed: float = 100000000.0
@export var FireCoolDown: float = 0.5
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

@onready var EndOfGun = $EndOfGun
var isShooting: bool = false

@export var Recoil = 5.0

@export var canShoot: bool = false

signal player_Fired_Bullet(Recoil)

func ShootRepeat():
	while isShooting and canShoot:
		await get_tree().create_timer(FireCoolDown).timeout
		shoot()
		
func shoot():
	print("Firing Weapon")
	var bullet_instance = Bullet.instantiate()
	audio_stream_player_2d.play()
	bullet_instance.global_position = EndOfGun.global_position
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_central_impulse(Vector2(bullet_speed,0).rotated(global_rotation))
	get_tree().get_root().add_child(bullet_instance)
	emit_signal("player_Fired_Bullet", Recoil)
