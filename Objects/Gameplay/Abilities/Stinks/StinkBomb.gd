class_name StinkBombAbility
extends Ability

func _activate_ability():
	super()
	player.knock_back.visible = true
	player.knock_back_collision.disabled = false
	await get_tree().create_timer(.4).timeout
	player.knock_back.visible = false
	player.knock_back_collision.disabled = true
