class_name ShotgunAbility
extends Ability

func _activate_ability():
	super()
	player._applyVelocity(30.0)
	player.weapon.shotgun()
