class_name GM extends Node2D

@onready var player:Player = $"../Player"
@onready var ability_pick_up:AbilityPickUp = $"../CanvasLayer/AbilityPickUp"

signal scoreChanged(score:int)
var Score:int = 0: set = newScore
		
@onready var death_sound = $"../DeathSound"
@onready var music:AudioStreamPlayer = $"../Music"
@onready var siren:AudioStreamPlayer = $"../Siren"

var seconds:int
@onready var timer = $Timer

@export var maxAbilityPickUps:int = 3
@onready var currentAbilityPickUps:int = 0
@export var spawnAbilitySecond:int = 30
@onready var currentSpawnAbilitySecond:int = 30
var canSpawnAbility:bool = false

static var gameManager:GM

func newScore(newValue):
	print("Score" + str(Score))
	Score = newValue
	emit_signal("scoreChanged", Score)

func addScore(adding:int):
	Score += adding

func _ready():
	if GM.gameManager == null:
		GM.gameManager = self
	else:
		queue_free()
	
	ability_pick_up.GameManager = self
	player.Death.connect(playDeath)
	await get_tree().create_timer(0.000000001).timeout
	player.health_component.Health_Change.connect(playSiren)

func playSiren(health:int):
	match health:
		1:
			siren.volume_db = -3
		2: 
			siren.volume_db = -6
		3:
			siren.volume_db = -15
		4:
			siren.volume_db = -80
	
func playDeath():
	siren.stop()
	music.stop()
	death_sound.play()

func _on_timer_timeout():
	seconds += 1
	if seconds == currentSpawnAbilitySecond:
		currentSpawnAbilitySecond += spawnAbilitySecond
		canSpawnAbility = true
	print("Seconds" + str(seconds))
