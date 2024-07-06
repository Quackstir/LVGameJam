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

var currentrecoil = 0.1

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


@onready var right = $Center/Right
@onready var down = $Center/Down
@onready var left = $Center/Left
@onready var up = $Center/Up

@onready var burst_icon = $"Burst Icon"
@onready var stink_bomb_icon = $"Stink Bomb Icon"
@onready var lazer_icon = $"Lazer Icon"
@onready var rockets_icon = $"Rockets Icon"

@onready var light_bulb:LightBulb = $"Center/Light Bulb"
@onready var light_bulb_2:LightBulb = $"Center/Light Bulb2"
@onready var light_bulb_3:LightBulb = $"Center/Light Bulb3"
@onready var light_bulb_4:LightBulb = $"Center/Light Bulb4"

@onready var burst_ability = $BurstAbility
@onready var stink_bomb_ability = $"Stink Bomb Ability"
@onready var lazer_ability = $"Lazer Ability"
@onready var barrage_ability = $"Barrage Ability"

@onready var lazer = $Center/Weapon/Lazer
@onready var lazer_collision = $Center/Weapon/Lazer/LazerCollision

@onready var knock_back = $KnockBack
@onready var knock_back_collision = $KnockBack/KnockBackCollision

func _ready():
	BurstConnect()
	StinkbombConnect()
	LazerConnect()
	BarrageConnect()

	weapon.connect("player_Fired_Bullet", _applyVelocity)
	InputHelper.device_changed.connect(_on_input_device_changed)
	hit_box_component.hurt.connect(onHurt)
	health_component.Health_Change.connect(healthChange)

#func addAbility(newAbility:Ability):
	#match newAbility.abilityType:
		#Ability.AbilityType.Lazer:
			#BurstConnect()

func BurstConnect():
	burst_ability.setPlayer(self)
	burst_ability.connect("abilityUse",burstIconVisible)

func StinkbombConnect():
	stink_bomb_ability.setPlayer(self)
	stink_bomb_ability.connect("abilityUse", stinkBombIconVisible)

func LazerConnect():
	lazer_ability.setPlayer(self)
	lazer_ability.connect("abilityUse", lazerIconVisible)

func BarrageConnect():
	barrage_ability.setPlayer(self)
	barrage_ability.connect("abilityUse",BarrageIconVisible)
	
func burstIconVisible(canUse):
	burst_icon.visible = canUse

func lazerIconVisible(canUse):
	lazer_icon.visible = canUse

func stinkBombIconVisible(canUse):
	stink_bomb_icon.visible = canUse
	
func BarrageIconVisible(canUse):
	rockets_icon.visible = canUse

func healthChange(health:int):
	match health_component.Curr_Health:
		4:
			light_bulb.isBroken = false
			light_bulb_2.isBroken = false
			light_bulb_3.isBroken = false
			light_bulb_4.isBroken = false
		3:
			light_bulb.isBroken = true
			light_bulb_2.isBroken = false
			light_bulb_3.isBroken = false
			light_bulb_4.isBroken = false
		2:
			light_bulb.isBroken = true
			light_bulb_2.isBroken = true
			light_bulb_3.isBroken = false
			light_bulb_4.isBroken = false
		1:
			light_bulb.isBroken = true
			light_bulb_2.isBroken = true
			light_bulb_3.isBroken = true
			light_bulb_4.isBroken = false
		0:
			light_bulb.isBroken = true
			light_bulb_2.isBroken = true
			light_bulb_3.isBroken = true
			light_bulb_4.isBroken = true

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

	currentrecoil = lerp(currentrecoil,0.0,delta * 20)
	print("current recoil: " + str(currentrecoil))
	velocity = lerp(velocity, -center.transform.x * currentrecoil * SPEED, delta * Acceleration)
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
	
	move_and_slide()
	
func Ability():
	if Input.is_action_just_pressed("Weapon South"): #down
		burst_ability._use_ability()

	elif Input.is_action_just_pressed("Weapon East"):
		lazer_ability._use_ability()
		
	elif Input.is_action_just_pressed("Weapon West"):
		stink_bomb_ability._use_ability()
		
	elif Input.is_action_just_pressed("Weapon North"):
		barrage_ability._use_ability()
		
func MovementInput():
	if !canRotate:return
	
	if CurrentDevice != "keyboard":
		var HorizontalMovement = Input.get_action_raw_strength("Movement_Right") - Input.get_action_raw_strength("Movement_Left")
		var VerticalMovement = Input.get_action_raw_strength("Movement_Down") - Input.get_action_raw_strength("Movement_Up")
		playerMovement = Vector2(HorizontalMovement, VerticalMovement)
		return

	if Input.is_action_pressed("Select"):
		playerMovement = (get_global_mouse_position() - position)
	elif Input.is_action_just_released("Select"):
		playerMovement = Vector2.ZERO
	
func  _applyVelocity(Recoil):
	currentrecoil = Recoil
	
func _on_health_component_on_death():
	if canMove:
		emit_signal("Death")
		canMove = false
		camera_2d.apply_shake()
