extends Area2D

class_name DamageBoxComponent

# Export the damage amount this hitbox deals
@export var damage = 1.0

# Create a signal for when the hitbox hits a hurtbox
signal hit_hurtbox(hurtbox)

func _ready():
	# Connect on area entered to our hurtbox entered function
	area_entered.connect(_on_hurtbox_entered)

func _on_hurtbox_entered(hitbox: HitboxComponent):
	# Make sure the area we are overlapping is a hurtbox
	if not hitbox is HitboxComponent: return
	# Make sure the hurtbox isn't invincible
	#if hitbox.is_invincible: return
	# Signal out that we hit a hurtbox (this is useful for destroying projectiles when they hit something)
	hit_hurtbox.emit(hitbox)
	# Have the hurtbox signal out that it was hit
	hitbox.hurt.emit(damage)
