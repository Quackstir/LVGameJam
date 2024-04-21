extends Control

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if not self.is_visible_in_tree():
			# Pause the game when the pause menu is not visible
			self.show()
			get_tree().paused = true
		else:
			self.hide()
			get_tree().paused = false


