class_name Ability
extends Node2D

enum AbilityType{Barrage,Lazer,Bomb,Burst}

@onready var cooldown = %Cooldown
@onready var ability_ready_sfx:AudioStreamPlayer2D = %"Ability Ready SFX"
@onready var ability_activate_sfx:AudioStreamPlayer2D = %"Ability Activate SFX"
@export var abilityType:AbilityType = AbilityType.Burst

var canUse:bool = true:
	set(newValue):
		canUse = newValue
		emit_signal("abilityUse",newValue)
signal abilityUse(Usable:bool)

var player:Player

func setPlayer(newPlayer):
	player = newPlayer

func _use_ability():
	cooldown.start()
	if canUse:
		_activate_ability()
	canUse = false

func _activate_ability():
	ability_activate_sfx.play()
	
func _on_cooldown_timeout():
	canUse = true
	ability_ready_sfx.play()
