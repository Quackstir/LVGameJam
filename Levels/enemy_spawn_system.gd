extends Node

@export var EnemyInstance: PackedScene
@export var Enemy_Dragonfly_Instance: PackedScene

@onready var spawn_timer: Timer = $spawnTimer
@onready var game_manager: GM = $".."

@onready var path_follow_2d: PathFollow2D = %PathFollow2D

func SpawnEnemy(Enemy:PackedScene):
	var enemy_instance = Enemy.instantiate()
	enemy_instance._set_Player(game_manager.player)
	enemy_instance._set_GM(game_manager)
	
	add_child(enemy_instance)

	path_follow_2d.progress_ratio = randf()
	enemy_instance.global_position = path_follow_2d.global_position


func _on_spawn_timer_timeout():
	SpawnEnemy(EnemyInstance)
	
	if spawn_timer.wait_time > 0.5:
		spawn_timer.wait_time -= 0.02
		print(spawn_timer.wait_time)
	
	if game_manager.seconds < 60:return
	if randf_range(0,1) < 0.3:
		SpawnEnemy(Enemy_Dragonfly_Instance)
