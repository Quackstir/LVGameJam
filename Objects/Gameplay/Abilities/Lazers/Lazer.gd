class_name LazerAbility
extends Ability

@onready var lazer_activate = $lazerActivate

func _activate_ability():
	super()
	player.weapon.canShoot = false
	player.lazer.visible = true
	lazer_activate.start()
	player.canRotate = false
	player.lazer_collision.disabled = false
	while (lazer_activate.time_left > 0):
		await get_tree().create_timer(.1).timeout
		print("Lazering" + str(lazer_activate.time_left))
		player._applyVelocity(6.0)
		if lazer_activate.time_left <= 0 : return


func _on_lazer_activate_timeout():
	player.lazer.visible = false
	player.weapon.canShoot = true
	#player._applyVelocity(0.0)
	player.canRotate = true
	player.lazer_collision.disabled = true
