class_name GameManager extends Node2D

@export var EnemyInstance: PackedScene
@onready var path_follow_2d = %PathFollow2D
@onready var player = $"../Player"


signal scoreChanged(score:int)
var Score:int = 0: set = newScore
		
@onready var death_sound = $"../DeathSound"
@onready var music:AudioStreamPlayer = $"../Music"
@onready var siren:AudioStreamPlayer = $"../Siren"

func newScore(newValue):
	print("Score" + str(Score))
	Score = newValue
	emit_signal("scoreChanged", Score)

func addScore(adding:int):
	Score += adding

func _ready():
	EnemySpawnRepeat()
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

func EnemySpawnRepeat():
	while true:
		await get_tree().create_timer(0.5).timeout
		SpawnEnemy()
		
func SpawnEnemy():
	var enemy_instance = EnemyInstance.instantiate()
	enemy_instance._set_Player(player)
	enemy_instance._set_GM(self)
	
	path_follow_2d.progress_ratio = randf()
	enemy_instance.global_position = path_follow_2d.global_position

	add_child(enemy_instance)
	
