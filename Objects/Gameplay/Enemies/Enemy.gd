extends CharacterBody2D

# Movement speed
@export var speed = 100 
var player_position
var target_position
# Get a reference to the player. It's likely different in your project
var player
var gameManager:GM
@onready var animation = $AnimationPlayer

@onready var hit_box_component = $HitBoxComponent
@onready var health_component = $HealthComponent

@onready var damage_box_component: DamageBoxComponent = $DamageBoxComponent as DamageBoxComponent
@export var momentumMovement:bool = true

var canMove:bool = true

@onready var timer = $Timer

@export var abilityPickup:PackedScene
@export var abilityResource:AbilityResource

func _ready():
	animation.play("ant_idle")
	velocity = Vector2.ZERO
	health_component.connect("onDeath", destroySelf)
	
func destroySelf():
	var  rng = RandomNumberGenerator.new()
	rng.randomize()
	var a = rng.randi_range(0,100)
	print("Spawn thing: " + str(a))
	if a > 20 and gameManager.currentAbilityPickUps < gameManager.maxAbilityPickUps and gameManager.canSpawnAbility:
		gameManager.canSpawnAbility = false
		gameManager.currentAbilityPickUps += 1
		var newPickup:AbilityDrop = abilityPickup.instantiate()
		newPickup.currentAbility = abilityResource
		newPickup.global_position = global_position
		get_tree().current_scene.add_child(newPickup)
		print("Current Abilities: " + str(gameManager.currentAbilityPickUps))
		
	gameManager.addScore(10)
	
func _set_Player(a:CharacterBody2D):
	player = a
	
func _set_GM(a:GM):
	gameManager = a
 
func _physics_process(delta):
	move_and_slide()
	if !canMove:return
	# Set player_position to the position of the player node
	player_position = player.position
	# Calculate the target position
	target_position = (player_position - position).normalized()
 
	# Check if the enemy is in a 3px range of the player, if not move to the target position
	if position.distance_to(player_position) > 3:
		if !momentumMovement:
			velocity = target_position * speed
			look_at(player_position)
		else:
			velocity = lerp(velocity, 400 * target_position, delta  * 0.5)
			var rotationDirection: float = target_position.angle()
			var currentRotation: float = global_rotation
			global_rotation = lerp_angle(currentRotation, rotationDirection, delta * 0.3)
		move_and_slide()

func _on_damage_box_component_hit_hurtbox(hurtbox):
	queue_free()

func stunEnemy():
	canMove = false
	timer.start()
	
func _on_timer_timeout():
	canMove = true
