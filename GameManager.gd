class_name GameManager extends Node2D

@export var EnemyInstance: PackedScene
@onready var path_follow_2d = %PathFollow2D
@onready var player = $"../Player"


signal scoreChanged(score:int)
var Score:int = 0: set = newScore
		

func newScore(newValue):
	emit_signal("scoreChanged", Score)
	print("Score" + str(Score))
	Score = newValue

func addScore(adding:int):
	Score += adding

func _ready():
	EnemySpawnRepeat()

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
	
