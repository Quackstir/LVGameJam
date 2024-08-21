#class_name OptionsMenu
#extends Control
#
#@onready var exit_button = $MarginContainer/VBoxContainer/Exit_button as button
#
#signal exit_options_menu
#
#func _ready():
	#exit_button.button_down.connect(on_exit_pressed)
	#set_pressed(false)
#
#func on_exit_pressed() -> void:
	#exit_options_menu.emit()
	#set_process(false)

#func _input(event):
	#if event.is_action_pressed("ui_cancel"):
		#if not self.is_visible_in_tree():
			## Pause the game when the pause menu is not visible
			#self.show()
			#get_tree().paused = true
		#else:
			#self.hide()
			#get_tree().paused = false
#

