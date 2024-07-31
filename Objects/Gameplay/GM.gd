class_name GM extends Node2D

@export var EnemyInstance: PackedScene
@export var Enemy_Dragonfly_Instance: PackedScene
@onready var path_follow_2d = %PathFollow2D
@onready var player:Player = $"../Player"
@onready var ability_pick_up:AbilityPickUp = $"../CanvasLayer/AbilityPickUp"

signal scoreChanged(score:int)
var Score:int = 0: set = newScore
		
@onready var death_sound = $"../DeathSound"
@onready var music:AudioStreamPlayer = $"../Music"
@onready var siren:AudioStreamPlayer = $"../Siren"

var seconds:int
@onready var timer = $Timer
@onready var spawn_timer = $spawnTimer

func newScore(newValue):
	print("Score" + str(Score))
	Score = newValue
	emit_signal("scoreChanged", Score)

func addScore(adding:int):
	Score += adding

func _ready():
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

func SpawnEnemy(Enemy:PackedScene):
	var enemy_instance = Enemy.instantiate()
	enemy_instance._set_Player(player)
	enemy_instance._set_GM(self)

	path_follow_2d.progress_ratio = randf()
	enemy_instance.global_position = path_follow_2d.global_position

	add_child(enemy_instance)

func _on_timer_timeout():
	seconds += 1
	print("Seconds" + str(seconds))

func _on_spawn_timer_timeout():
	SpawnEnemy(EnemyInstance)
	
	if spawn_timer.wait_time > 0.5:
		spawn_timer.wait_time -= 0.02
		print(spawn_timer.wait_time)
	
	if seconds < 60:return
	if randf_range(0,1) < 0.3:
		SpawnEnemy(Enemy_Dragonfly_Instance)
