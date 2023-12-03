extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var Acceleration = 10.0

@onready var center = $Center
@onready var weapon: WeaponComponent = $Center/Weapon
@onready var weapon_2: WeaponComponent = $Center/Weapon2
@onready var weapon_3: WeaponComponent = $Center/Weapon3
@onready var weapon_4: WeaponComponent = $Center/Weapon4

var CurrentSelectedWeapon: int = 0
@onready var Weapons: Array[WeaponComponent] = [weapon, weapon_2, weapon_3, weapon_4]

var playerMovement := Vector2.ZERO
var isPlayerMoving = false
var playerStartedMoving = false

var currentrecoil = 10.0

@export var EnemyInstance: PackedScene
@onready var health_component = $HealthComponent


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	weapon.connect("player_Fired_Bullet", _applyVelocity)
	weapon_2.connect("player_Fired_Bullet", _applyVelocity)
	weapon_3.connect("player_Fired_Bullet", _applyVelocity)
	weapon_4.connect("player_Fired_Bullet", _applyVelocity)
	EnemySpawnRepeat()
	

func _process(delta):
	if Input.is_action_just_pressed("Weapon North"):
		CurrentSelectedWeapon = 0
		_switch_weapon()
	if Input.is_action_just_pressed("Weapon East"):
		CurrentSelectedWeapon = 1
		_switch_weapon()
	if Input.is_action_just_pressed("Weapon South"):
		CurrentSelectedWeapon = 2
		_switch_weapon()
	if Input.is_action_just_pressed("Weapon West"):
		CurrentSelectedWeapon = 3
		_switch_weapon()
	print(CurrentSelectedWeapon)

func _switch_weapon():
	for n in Weapons:
		n.canShoot = false
		
	Weapons[CurrentSelectedWeapon].canShoot = true
	

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	MovementInput()
	
	center.look_at(playerMovement + position)
	
	isPlayerMoving = playerMovement.length() > 0.3
	if (isPlayerMoving):
		if (!playerStartedMoving):
			Weapons[CurrentSelectedWeapon].isShooting = true
			Weapons[CurrentSelectedWeapon].ShootRepeat()
			print("Shooting")
			playerStartedMoving = true
	else:
		playerStartedMoving = false
		Weapons[CurrentSelectedWeapon].isShooting = false
		Weapons[CurrentSelectedWeapon].ShootRepeat()
	
	currentrecoil = lerp(currentrecoil,0.0,delta * 20)
	velocity = lerp(velocity, -playerMovement * currentrecoil * SPEED, delta * Acceleration)
	move_and_slide()
	
	

func MovementInput():
	var HorizontalMovement = Input.get_action_raw_strength("Movement_Right") - Input.get_action_raw_strength("Movement_Left")
	var VerticalMovement = Input.get_action_raw_strength("Movement_Down") - Input.get_action_raw_strength("Movement_Up")
	
	playerMovement = Vector2(HorizontalMovement, VerticalMovement)
	print("PlayerInput Stick: " + str(playerMovement))
	
func  _applyVelocity(Recoil):
	currentrecoil = Recoil
	
func EnemySpawnRepeat():
	while true:
		await get_tree().create_timer(0.5).timeout
		SpawnEnemy()
		
func SpawnEnemy():
	var enemy_instance = EnemyInstance.instantiate()
	enemy_instance.global_position = self.position + Vector2(200,200)
	enemy_instance._set_Player(self)
	get_tree().get_root().add_child(enemy_instance)
	
