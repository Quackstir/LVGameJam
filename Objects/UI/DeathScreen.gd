extends Control

@export var gameManager: GameManager
@export var player: Player
@onready var label_2 = $Panel/MarginContainer/VBoxContainer/Label2

func _ready():
	player.Death.connect(appearOnDeath)
	
func appearOnDeath():
	visible = true
	label_2.text = "Score: " + str(gameManager.Score)

func _on_reset_button_down():
	get_tree().change_scene_to_file("res://Levels/Level.tscn")

func _on_exit_game_button_down():
	get_tree().quit()


#func _on_visibility_changed():
	#label_2.text = "Score: " + str(gameManager.Score)
