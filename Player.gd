extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var Acceleration = 10.0

@onready var w = $w
@onready var weapon: WeaponComponent = $w/Weapon

var playerMovement := Vector2.ZERO
var isPlayerMoving = false
var playerStartedMoving = false

var currentrecoil = 10.0

@export var EnemyInstance: PackedScene

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	weapon.connect("player_Fired_Bullet", _applyVelocity)
	EnemySpawnRepeat()

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	MovementInput()
	
	w.look_at(playerMovement + position)
	
	isPlayerMoving = playerMovement.length() > 0.3
	if (isPlayerMoving):
		if (!playerStartedMoving):
			weapon.isShooting = true
			weapon.ShootRepeat()
			print("Shooting")
			playerStartedMoving = true
	else:
		playerStartedMoving = false
		weapon.isShooting = false
		weapon.ShootRepeat()
	
	currentrecoil = lerp(currentrecoil,0.0,delta * 20)
	velocity = lerp(velocity, -playerMovement * currentrecoil * SPEED, delta * Acceleration)
	move_and_slide()
	
	

func MovementInput():
	var HorizontalMovement = Input.get_axis("Movement_Left", "Movement_Right")
	var VerticalMovement = Input.get_axis("Movement_Up", "Movement_Down")
	
	playerMovement = Vector2(HorizontalMovement, VerticalMovement)
	
func  _applyVelocity(Recoil):
	currentrecoil = Recoil
	
func EnemySpawnRepeat():
	while true:
		await get_tree().create_timer(0.5).timeout
		SpawnEnemy()
		
func SpawnEnemy():
	var enemy_instance = EnemyInstance.instantiate()
	enemy_instance.global_position = Vector2(10,10)
	enemy_instance._set_Player(self)
	get_tree().get_root().add_child(enemy_instance)
	
