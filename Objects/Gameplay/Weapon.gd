extends Node2D

class_name WeaponComponent
@onready var animation = $AnimationPlayer

var isShoot: bool = false

@export var Bullet: PackedScene
@export var bullet_speed: float = 100000000.0
@export var FireCoolDown: float = 0.5
@export var BulletTowards: Array[Vector2]
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var shot_gun: AudioStreamPlayer2D = $shotGun

@export var player:Player

@onready var EndOfGun = $EndOfGun
var isShooting: bool = false

@export var Recoil:float = 10.0

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
	
func shotgun():
	canShoot = false
	#for fire in 5:
	shot_gun.play()
	shotgunFireBullet(0)
	shotgunFireBullet(6)
	shotgunFireBullet(-6)
	Recoil = 15.0
	canShoot = true

func ShootRepeat(isShooting):
	if isShooting:
		canShoot = true
		if fireFirstRound and timer.time_left < timer.wait_time:
			fireFirstRound = false
			fireWeapon()
			timer.stop()
		if timer.time_left <= 0:
			timer.start()
	else:
		canShoot = false

func fireWeapon():
	if !canShoot: return
	#Recoil = 10
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
	if player.health_component.Curr_Health <= 0: return
	
	var bullet_instance = Bullet.instantiate()
	animation.play("Gun")
	audio_stream_player_2d.play()
	bullet_instance.global_position = EndOfGun.global_position
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_central_impulse(Vector2(bullet_speed,0).rotated(global_rotation))
	get_tree().current_scene.add_child(bullet_instance)
	emit_signal("player_Fired_Bullet", Recoil)

func shotgunFireBullet(a:float):
	if player.health_component.Curr_Health <= 0: return
	
	#var  rng = RandomNumberGenerator.new()
	#rng.randomize()
	#var a = rng.randi_range(0,10)
		
	var bullet_instance = Bullet.instantiate()
	animation.play("Gun")
	audio_stream_player_2d.play()
	bullet_instance.global_position = EndOfGun.global_position
	bullet_instance.rotation_degrees = rotation_degrees 
	bullet_instance.apply_central_impulse(Vector2(bullet_speed,0).rotated(global_rotation + a))
	get_tree().current_scene.add_child(bullet_instance)
	emit_signal("player_Fired_Bullet", Recoil)
