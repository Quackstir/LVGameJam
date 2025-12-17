class_name StinkMineAbility
extends Ability

func _activate_ability():
	super()
	player.knock_back._enable_knockback()
	await get_tree().create_timer(.4).timeout
	player.knock_back._disable_knockback()
