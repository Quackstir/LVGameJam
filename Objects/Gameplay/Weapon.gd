extends Node2D

class_name WeaponComponent
@onready var animation = $AnimationPlayer

var isShoot: bool = false

@export var Bullet: PackedScene
@export var bullet_speed: float = 100000000.0
@export var FireCoolDown: float = 0.5
#@export var BulletTowards: Array[Vector2]
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@export var player:Player

@onready var EndOfGun = $EndOfGun
var isShooting: bool = false

@export var Recoil = 5.0

var canShoot: bool = false
var fireFirstRound:bool = true

signal player_Fired_Bullet(Recoil)
@onready var timer = $Timer

func _ready():	
	await get_tree().create_timer(0.000001).timeout
	timer.wait_time = FireCoolDown
	player.fireWeapon.connect(ShootRepeat)
	
func burstFire():
	canShoot = false
	for fire in 3:
		fireBullet()
		await get_tree().create_timer(0.1).timeout
	Recoil = 10.0
	canShoot = true

func ShootRepeat(isShooting):
	if isShooting:
		canShoot = true
		if fireFirstRound:
			fireFirstRound = false
			fireWeapon()
		if timer.time_left <= 0:
			timer.start()
	else:
		canShoot = false

func fireWeapon():
	if !canShoot: return
	print("Fire")
	for fire in 1:
		fireBullet()
		await get_tree().create_timer(0.1).timeout
	

func _on_timer_timeout():
	if canShoot:
		fireWeapon()
		print("TIMER FIRED")
	else:
		print("TIMER STOPPED")
		fireFirstRound = true

func fireBullet():
	var bullet_instance = Bullet.instantiate()
	animation.play("Gun")
	audio_stream_player_2d.play()
	bullet_instance.global_position = EndOfGun.global_position
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_central_impulse(Vector2(bullet_speed,0).rotated(global_rotation))
	get_tree().get_root().add_child(bullet_instance)
	emit_signal("player_Fired_Bullet", Recoil)
