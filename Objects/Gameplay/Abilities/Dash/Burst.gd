class_name BurstAbility
extends Ability

func _activate_ability():
	super()
	player._applyVelocity(13.0)
	player.weapon.burstFire()
