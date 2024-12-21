extends Control

@onready var pause_menu = $"CanvasLayer/Pause Menu Panel"
var paused = false

@export var bus_asset: BusAsset
var bus: Bus

func _on_resume_game_button_down():
	pauseMenu()

func _ready():
	pause_menu.hide()
	bus = FMODStudioModule.get_studio_system().get_bus(bus_asset.path)
	bus.set_paused(false)

func pauseMenu():
	if paused:
		pause_menu.hide()
		bus.set_paused(false)
		Engine.time_scale = 1
	else:
		pause_menu.show()
		bus.set_paused(true)
		Engine.time_scale = 0
	paused = !paused

func _on_button_pressed():
	get_tree().quit()

func _on_resume_game_pressed():
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://Levels/Level.tscn")
	
