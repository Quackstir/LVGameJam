extends Control

@onready var pause_menu = $"CanvasLayer/Pause Menu Panel"
@onready var resume: UI_Button = $"CanvasLayer/Pause Menu Panel/MarginContainer/VBoxContainer/HBoxContainer3/Resume"
@onready var restart_game: UI_Button = $"CanvasLayer/Pause Menu Panel/MarginContainer/VBoxContainer/HBoxContainer/Restart Game"
@onready var quit_game: UI_Button = $"CanvasLayer/Pause Menu Panel/MarginContainer/VBoxContainer/HBoxContainer2/Quit Game"

@onready var gameManager: GM = GM.gameManager
var canPause:bool = true
var paused = true:
	set(newValue):
		paused = newValue
		if !canPause:return
		if paused:
			pause_menu.hide()
			bus.set_paused(false)
			Engine.time_scale = 1
		else:
			pause_menu.show()
			bus.set_paused(true)
			Engine.time_scale = 0
			resume.disabled = false
			restart_game.disabled = false
			quit_game.disabled = false
			resume.grab_focus()

@export var bus_asset: BusAsset
var bus: Bus

func _input(event:InputEvent):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func _ready():
	pause_menu.hide()
	bus = FMODStudioModule.get_studio_system().get_bus(bus_asset.path)
	bus.set_paused(false)
	await get_tree().create_timer(0.00001).timeout
	gameManager.player.Death.connect(mustNotPause)

	Input.joy_connection_changed.connect(joy_connection)
	Steam.overlay_toggled.connect(steamOverlay)
	
func joy_connection(_device:int, _connected:bool)->void:
	if !_connected:
		print("disconnected") 
		paused = false
	else:
		print("connected")
	
func mustNotPause()->void:
	canPause = false

func pauseMenu():
	paused = !paused

func steamOverlay(toggled:bool,user_initiated: bool,app_id: int) -> void:
	if toggled: paused = false

func _on_resume_pressed_button() -> void:
	pauseMenu()

func _on_restart_game_pressed_button() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://Levels/Level.tscn")

func _on_quit_game_pressed_button() -> void:
	get_tree().quit()
