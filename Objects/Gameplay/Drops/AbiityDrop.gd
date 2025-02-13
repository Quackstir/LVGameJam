class_name AbilityDrop
extends Area2D
# Export the damage amount this hitbox deals
@export var currentAbility:AbilityResource

# Create a signal for when the hitbox hits a hurtbox
signal hit_hurtbox(hurtbox)

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var beetlglow: Sprite2D = $Beetlglow

func _ready():
	# Connect on area entered to our hurtbox entered function
	print("HEALTH DROPPED")
	_spin_gear()
	_glow()
	_shrink()

func _shrink():
	var tween:Tween = self.create_tween()
	tween.tween_property(self,"scale",Vector2(0.3,0.3), 3).set_delay(3)
	tween.set_parallel()
	tween.tween_property(self,"modulate",Color(Color.WHITE,0.0),4).set_delay(3)
	tween.chain().tween_callback(self._on_death)

func _on_death():
	GM.gameManager.currentAbilityPickUps -= 1
	queue_free()
	

func _spin_gear():
	var tween:Tween = sprite_2d.create_tween().set_loops()
	tween.tween_property(sprite_2d,"rotation_degrees",360, 5)
	tween.tween_property(sprite_2d,"rotation_degrees",0, 0)
	
func _glow():
	var tween:Tween = beetlglow.create_tween().set_loops()
	tween.tween_property(beetlglow,"modulate",Color(Color.WHITE,0.7),4)
	tween.tween_property(beetlglow,"modulate",Color(Color.WHITE,0.5),4)

func _on_area_entered(area):
	#print("AbilityDrop" + str(area.get_parent()))
	if not area.get_parent() is Player: return
	#var player:Player = area.get_parent()
	print("Ability Drop")
	get_tree().paused = true
	GM.gameManager.ability_pick_up.visible = true
	GM.gameManager.ability_pick_up.updateAbilityButtons()
	queue_free()
	
	#if !player.checkAbilityOccupied(currentAbility):
		#area.get_parent().addAbility(currentAbility)
		#queue_free()
