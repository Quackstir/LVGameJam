class_name Player
extends CharacterBody2D

@onready var hit_box_component:HitboxComponent = $HitBoxComponent
@onready var camera_2d:ScreenShake = $Camera2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var Acceleration = 10.0

#@export var po: Array[int]

@onready var center = $Center
@onready var weapon: WeaponComponent = $Center/Weapon

var CurrentSelectedWeapon: int = 0
@onready var Weapons: Array[WeaponComponent] = [weapon]

var playerMovement := Vector2.ZERO
var isPlayerMoving = false
var playerStartedMoving = false

var currentrecoil = 10.0

var canRotate : bool = true

@onready var health_component:HealthComponent = $HealthComponent
var CurrentDevice: String = "keyboard"
signal fireWeapon(isShooting:bool)
signal Death

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var canMove:bool = true
@onready var damage_audio = $"Damage Audio"
@onready var death_sound = $DeathSound

@onready var lazer = $Center/Weapon/Lazer
@onready var burst = $"Ability Cooldowns/Burst"
@onready var lazer_activate = $Center/Weapon/Lazer/LazerActivate
@onready var lazer_cool_down = $"Ability Cooldowns/LazerCoolDown"
@onready var lazer_collision = $Center/Weapon/Lazer/LazerCollision

@onready var knock_back = $KnockBack
@onready var knock_back_collision = $KnockBack/KnockBackCollision
@onready var knock_back_cool_down = $"Ability Cooldowns/KnockBackCoolDown"

@export var missle: PackedScene
@export var missle_speed: float = 100000000.0
@onready var right = $Center/Right
@onready var down = $Center/Down
@onready var left = $Center/Left
@onready var up = $Center/Up
@onready var missle_cool_down = $"Ability Cooldowns/MissleCoolDown"

@onready var burst_icon = $"Burst Icon"
@onready var stink_bomb_icon = $"Stink Bomb Icon"
@onready var lazer_icon = $"Lazer Icon"
@onready var rockets_icon = $"Rockets Icon"

@onready var lazer_audio = $"Ability Cooldowns/LazerCoolDown/Lazer Audio"
@onready var stinkbug_audio = $"Ability Cooldowns/KnockBackCoolDown/Stinkbug Audio"
@onready var missle_audio = $"Ability Cooldowns/MissleCoolDown/Missle Audio"

func _ready():
	weapon.connect("player_Fired_Bullet", _applyVelocity)
	#weapon_2.connect("player_Fired_Bullet", _applyVelocity)
	#weapon_3.connect("player_Fired_Bullet", _applyVelocity)
	#weapon_4.connect("player_Fired_Bullet", _applyVelocity)
	InputHelper.device_changed.connect(_on_input_device_changed)
	hit_box_component.hurt.connect(onHurt)

func onHurt(area: int):
	if !canMove: return
	camera_2d.apply_shake()
	damage_audio.play()

func _on_input_device_changed(device: String, device_index: int) -> void:
	print(device)
	CurrentDevice = device

func _switch_weapon():
	for n in Weapons:
		n.canShoot = false
		
	Weapons[CurrentSelectedWeapon].canShoot = true
	
func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_P:
			health_component._take_damage(1)
		if event.keycode == KEY_O:
			health_component._set_health(health_component.Curr_Health + 1)
	

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	if !canMove: 
		playerStartedMoving = false
		emit_signal("fireWeapon", false)
		move_and_slide()
		return
	Ability()
	MovementInput()

	isPlayerMoving = playerMovement.length() > 0.3
	if (isPlayerMoving):
		var rotationPosition: Vector2 = (playerMovement + position) - global_position
		var rotationDirection: float = rotationPosition.angle()
	
		center.global_rotation = rotationDirection
		if (!playerStartedMoving):
			emit_signal("fireWeapon", true)
			print("Shooting")
			playerStartedMoving = true
	else:
		playerStartedMoving = false
		emit_signal("fireWeapon", false)
	
	currentrecoil = lerp(currentrecoil,0.0,delta * 20)
	var ClampedInputLength = clamp(playerMovement.length(),0,1);
	velocity = lerp(velocity, center.transform.x * -ClampedInputLength * currentrecoil * SPEED, delta * Acceleration)
	move_and_slide()
	
func Ability():
	if Input.is_action_just_pressed("Weapon South"): #down
		if burst.time_left > 0: return
		weapon.Recoil = 13.0
		weapon.burstFire()
		burst.start()
		burst_icon.visible = false
	elif Input.is_action_just_pressed("Weapon East"):
		if lazer_cool_down.time_left > 0:return
		lazer_audio.play()
		lazer_cool_down.start()
		lazer_icon.visible = false
		weapon.canShoot = false
		lazer.visible = true
		lazer_activate.start()
		canRotate = false
		lazer_collision.disabled = false
		while (lazer_activate.time_left > 0):
			await get_tree().create_timer(.1).timeout
			print("Lazering" + str(lazer_activate.time_left))
			_applyVelocity(6.0)
			if lazer_activate.time_left <= 0 : return
	elif Input.is_action_just_pressed("Weapon West"):
		if knock_back_cool_down.time_left > 0:return
		stinkbug_audio.play()
		stink_bomb_icon.visible = false
		knock_back_cool_down.start()
		knock_back.visible = true
		knock_back_collision.disabled = false
		await get_tree().create_timer(.4).timeout
		knock_back.visible = false
		knock_back_collision.disabled = true
	elif Input.is_action_just_pressed("Weapon North"):
		if missle_cool_down.time_left > 0:return
		missle_audio.play()
		missle_cool_down.start()
		fireBullet(up)
		fireBullet(down)
		fireBullet(left)
		fireBullet(right)
		rockets_icon.visible = false
		
func MovementInput():
	if !canRotate:return
	
	if CurrentDevice != "keyboard":
		var HorizontalMovement = Input.get_action_raw_strength("Movement_Right") - Input.get_action_raw_strength("Movement_Left")
		var VerticalMovement = Input.get_action_raw_strength("Movement_Down") - Input.get_action_raw_strength("Movement_Up")
		playerMovement = Vector2(HorizontalMovement, VerticalMovement)
		return
	#print("PlayerInput Stick: " + str(playerMovement))
	
	if Input.is_action_pressed("Select"):
		playerMovement = (get_global_mouse_position() - position)
	elif Input.is_action_just_released("Select"):
		playerMovement = Vector2.ZERO
	
func  _applyVelocity(Recoil):
	currentrecoil = Recoil
	
func _on_health_component_on_death():
	#queue_free()
	if canMove:
		emit_signal("Death")
		canMove = false
		camera_2d.apply_shake()
		#damage_audio.play()
		#death_sound.play()

func _on_lazer_activate_timeout():
	lazer.visible = false
	weapon.canShoot = true
	_applyVelocity(0.0)
	canRotate = true
	lazer_collision.disabled = true
	
func fireBullet(direction):
	var missle_instance = missle.instantiate()
	#audio_stream_player_2d.play()
	missle_instance.global_position = direction.global_position
	missle_instance.rotation_degrees = direction.rotation_degrees
	missle_instance.apply_central_impulse(Vector2(missle_speed,0).rotated(direction.global_rotation))
	get_tree().get_root().add_child(missle_instance)


func _on_burst_timeout():
	burst_icon.visible = true

func _on_lazer_cool_down_timeout():
	lazer_icon.visible = true

func _on_missle_cool_down_timeout():
	rockets_icon.visible = true

func _on_knock_back_cool_down_timeout():
	stink_bomb_icon.visible = true
