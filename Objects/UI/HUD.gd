extends Control

@export var gameManager:GM
@onready var label = $MarginContainer/Panel/MarginContainer/Label

# Called whesn the node enters the scene tree for the first time.
func _ready():
	label.text = "Score: 0"
	gameManager.scoreChanged.connect(updateScore)
	
func updateScore(score:int):
	label.text = "Score: " + str(score)
