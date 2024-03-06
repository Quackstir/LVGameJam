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

@onready var health_component = $HealthComponent
var CurrentDevice: String = "keyboard"
signal fireWeapon(isShooting:bool)
signal Death

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var canMove:bool = true
@onready var damage_audio = $"Damage Audio"

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
	

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if !canMove: 
		playerStartedMoving = false
		emit_signal("fireWeapon", true)
		return
	MovementInput()
	
	var rotationPosition: Vector2 = (playerMovement + position) - global_position
	var rotationDirection: float = rotationPosition.angle()
	
	global_rotation = rotationDirection
	
	isPlayerMoving = playerMovement.length() > 0.3
	if (isPlayerMoving):
		if (!playerStartedMoving):
			emit_signal("fireWeapon", true)
			print("Shooting")
			playerStartedMoving = true
	else:
		playerStartedMoving = false
		emit_signal("fireWeapon", true)
	
	currentrecoil = lerp(currentrecoil,0.0,delta * 20)
	var ClampedInputLength = clamp(playerMovement.length(),0,1);
	velocity = lerp(velocity, transform.x * -ClampedInputLength * currentrecoil * SPEED, delta * Acceleration)
	move_and_slide()
	
	

func MovementInput():
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
	emit_signal("Death")
	#queue_free()
	if canMove: 
		canMove = false
		camera_2d.apply_shake()
		damage_audio.play()
