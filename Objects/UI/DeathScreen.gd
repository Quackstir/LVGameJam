extends Control

@export var gameManager: GM
@export var player: Player
@onready var label_2 = $Panel/MarginContainer/VBoxContainer/Label2
@onready var reset: Button = $"Panel/MarginContainer/VBoxContainer/Reset Container/Reset"

func _ready():
	player.Death.connect(appearOnDeath)
	
func appearOnDeath():
	visible = true
	reset.grab_focus()
	label_2.text = "Score: " + str(gameManager.Score)

#func _on_visibility_changed():
	#label_2.text = "Score: " + str(gameManager.Score)


func _on_reset_pressed_button() -> void:
	get_tree().change_scene_to_file("res://Levels/Level.tscn")


func _on_exit_game_pressed_button() -> void:
	get_tree().quit()


func _on_credits_pressed_button() -> void:
	get_tree().change_scene_to_file("res://Levels/CreditsMenu.tscn")


func _on_main_menu_pressed_button() -> void:
	get_tree().change_scene_to_file("res://Levels/menu.tscn")
