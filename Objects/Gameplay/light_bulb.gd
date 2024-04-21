class_name LightBulb

extends Node2D

@onready var light_bulb_broke = $"Light Bulb Broke"
@onready var light_bulb_good = $"Light Bulb Good"

var isBroken:bool = false:
	set(newValue):
		isBroken = newValue
		break_bulb()
	get: 
		return isBroken

func break_bulb():
	light_bulb_good.visible = !isBroken
	light_bulb_broke.visible = isBroken
