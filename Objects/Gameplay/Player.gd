class_name Player
extends CharacterBody2D

@onready var hit_box_component:HitboxComponent = $HitBoxComponent
@onready var camera_2d:ScreenShake = $Camera2D
@onready var pause_menu = $"Pause Menu"

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

@onready var lazer = $Center/Weapon/Lazer
@onready var lazer_collision = $Center/Weapon/Lazer/LazerCollision

@onready var knock_back = $KnockBack
@onready var knock_back_collision = $KnockBack/KnockBackCollision

var burst_ability:Ability
var stink_bomb_ability:Ability
var lazer_ability:Ability
var barrage_ability:Ability

func _ready():
	#BurstConnect()
	#StinkbombConnect()
	#LazerConnect()
	#BarrageConnect()

	weapon.connect("player_Fired_Bullet", _applyVelocity)
	InputHelper.device_changed.connect(_on_input_device_changed)
	hit_box_component.hurt.connect(onHurt)
	health_component.Health_Change.connect(healthChange)

#func addAbility(newAbility:Ability):
	#match newAbility.abilityType:
		#Ability.AbilityType.Lazer:
			#BurstConnect()

func addAbility(abilityResource:AbilityResource):
	var spawnedItem:Ability = abilityResource.AbilityScene.instantiate()
	get_tree().get_root().add_child(spawnedItem)
	spawnedItem.setPlayer(self)
	
	match spawnedItem.abilityType:
		Ability.AbilityType.Burst:
			BurstConnect(spawnedItem)
		Ability.AbilityType.Barrage:
			BarrageConnect(spawnedItem)
		Ability.AbilityType.Bomb:
			StinkbombConnect(spawnedItem)
		Ability.AbilityType.Lazer:
			LazerConnect(spawnedItem)

func checkAbilityOccupied(abilityResource:AbilityResource) -> bool:
	match abilityResource.Type:
		Ability.AbilityType.Burst:
			if burst_ability != null:
				return true
		Ability.AbilityType.Barrage:
			if barrage_ability != null:
				return true
		Ability.AbilityType.Bomb:
			if stink_bomb_ability != null:
				return true
		Ability.AbilityType.Lazer:
			if lazer_ability != null:
				return true
	return false

func BurstConnect(burstAbility:Ability):
	burstAbility.setPlayer(self)
	burstAbility.connect("abilityUse",burstIconVisible)
	burst_ability = burstAbility
	burstIconVisible(true)
	
func StinkbombConnect(stink_bombAbility:Ability):
	stink_bombAbility.setPlayer(self)
	stink_bombAbility.connect("abilityUse", stinkBombIconVisible)
	stink_bomb_ability = stink_bombAbility
	stinkBombIconVisible(true)

func LazerConnect(lazerAbility:Ability):
	lazerAbility.setPlayer(self)
	lazerAbility.connect("abilityUse", lazerIconVisible)
	lazer_ability = lazerAbility
	lazerIconVisible(true)

func BarrageConnect(barrageAbility:Ability):
	barrageAbility.setPlayer(self)
	barrageAbility.connect("abilityUse",BarrageIconVisible)
	barrage_ability = barrageAbility
	BarrageIconVisible(true)
	
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
			
		if event.keycode == KEY_ESCAPE:
			pause_menu.pauseMenu()
	

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
	AbilityActivate()
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
	
func AbilityActivate():
	if Input.is_action_just_pressed("Weapon South") and burst_ability != null: #down
		burst_ability._use_ability()
		#burst_ability.queue_free()
		burstIconVisible(false)

	elif Input.is_action_just_pressed("Weapon East") and lazer_ability != null:
		lazer_ability._use_ability()
		#lazer_ability.queue_free()
		lazerIconVisible(false)
		
	elif Input.is_action_just_pressed("Weapon West") and stink_bomb_ability != null:
		stink_bomb_ability._use_ability()
		#stink_bomb_ability.queue_free()
		stinkBombIconVisible(false)
		
	elif Input.is_action_just_pressed("Weapon North") and barrage_ability != null:
		barrage_ability._use_ability()
		#barrage_ability.queue_free()
		BarrageIconVisible(false)
		
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
