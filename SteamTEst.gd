class_name SteamTest
extends Node

var AppID = "3396930"

func _init() -> void:
	OS.set_environment("SteamAppID", AppID)
	OS.set_environment("SteamGameID", AppID)
	
func _ready() -> void:
	Steam.steamInit()
	
	var isRunning = Steam.isSteamRunning()
	
	if !isRunning:
		print("ERROR: Steam not running!")
		return
		
	print("Steam is Running")
