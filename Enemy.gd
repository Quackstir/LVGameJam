extends CharacterBody2D

# Movement speed
@export var speed = 100 
var player_position
var target_position
# Get a reference to the player. It's likely different in your project
var player

func _ready():
	velocity = Vector2.ZERO

func _set_Player(a:CharacterBody2D):
	player = a
 
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
