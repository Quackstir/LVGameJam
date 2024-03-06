extends CharacterBody2D

# Movement speed
@export var speed = 100 
var player_position
var target_position
# Get a reference to the player. It's likely different in your project
var player
var gameManager:GameManager

@onready var hit_box_component = $HitBoxComponent
@onready var health_component = $HealthComponent

@onready var damage_box_component: DamageBoxComponent = $DamageBoxComponent as DamageBoxComponent

func _ready():
	velocity = Vector2.ZERO
	health_component.connect("onDeath", destroySelf)
	
func destroySelf():
	gameManager.addScore(10)
	queue_free()
	
func _set_Player(a:CharacterBody2D):
	player = a
	
func _set_GM(a:GameManager):
	gameManager = a
 
func _physics_process(delta):
	
	# Set player_position to the position of the player node
	player_position = player.position
	# Calculate the target position
	target_position = (player_position - position).normalized()
 
	# Check if the enemy is in a 3px range of the player, if not move to the target position
	if position.distance_to(player_position) > 3:
		velocity = target_position * speed
		move_and_slide()
		look_at(player_position)


func _on_damage_box_component_hit_hurtbox(hurtbox):
	queue_free()
