extends HBoxContainer

@onready var move_anchor: TextureRect = %"Move Anchor"
@onready var joystick: TextureRect = %Joystick

@export var move_joystick_texture:Texture2D
@export var move_mouse_texture:Texture2D
@export var move_multi:float = 30

@onready var burst_button: TextureRect = $"Burst/Panel/Burst Button"
@onready var bomb_button: TextureRect = $"Bomb/Panel/Bomb Button"
@onready var barrage_button: TextureRect = $"Barrage/Panel/Barrage Button"
@onready var lazer_button: TextureRect = $"Lazer/Panel/Lazer Button"

@onready var burst: VBoxContainer = $Burst
@onready var bomb: VBoxContainer = $Bomb
@onready var barrage: VBoxContainer = $Barrage
@onready var lazer: VBoxContainer = $Lazer

@onready var burst_icon: NinePatchRect = $"Burst/Burst Icon"
@onready var bomb_icon: NinePatchRect = $"Bomb/Bomb Icon"
@onready var barrage_icon: NinePatchRect = $"Barrage/Barrage Icon"
@onready var lazer_icon: NinePatchRect = $"Lazer/Lazer Icon"

@onready var initial_burst_color:Color = burst_icon.self_modulate
@onready var initial_bomb_color:Color = bomb_icon.self_modulate
@onready var initial_barrage_color:Color = barrage_icon.self_modulate
@onready var initial_lazer_color:Color = lazer_icon.self_modulate

@export var usedColor:Color

@export_category("Button Button Textures")
@export_subgroup("Controller Buttons")
@export var button_burst_controller:Texture2D
@export var button_bomb_controller:Texture2D
@export var button_barrage_controller:Texture2D
@export var button_lazer_controller:Texture2D
@export_subgroup("Keyboard Buttons")
@export var button_burst_Keyboard:Texture2D
@export var button_bomb_Keyboard:Texture2D
@export var button_barrage_Keyboard:Texture2D
@export var button_lazer_Keyboard:Texture2D

var player:Player
func _ready() -> void:
	player = GM.gameManager.player
	player.Ability_added.connect(_ability_acquired)
	player.Ability_used.connect(_ability_used)
	joystick.pivot_offset = joystick.pivot_offset /2
	
	burst.visible = false
	bomb.visible = false
	barrage.visible = false
	lazer.visible = false

func _ability_used(usedAbility : Ability.AbilityType, canUsed:bool):
	print(str(usedAbility) + " + " + str(canUsed))
	match usedAbility:
		Ability.AbilityType.Burst:
			burst_icon.self_modulate = initial_burst_color if canUsed else usedColor
			$"Burst/Panel/Burst Button".visible = canUsed
		Ability.AbilityType.Barrage:
			barrage_icon.self_modulate = initial_barrage_color if canUsed else usedColor
			$"Barrage/Panel/Barrage Button".visible = canUsed
		Ability.AbilityType.Bomb:
			bomb_icon.self_modulate = initial_bomb_color if canUsed else usedColor
			$"Bomb/Panel/Bomb Button".visible = canUsed
		Ability.AbilityType.Lazer:
			lazer_icon.self_modulate = initial_lazer_color if canUsed else usedColor
			$"Lazer/Panel/Lazer Button".visible = canUsed

func _ability_acquired(newAbility : Ability.AbilityType):
	match newAbility:
		Ability.AbilityType.Burst:
			burst.visible = true
		Ability.AbilityType.Barrage:
			barrage.visible = true
		Ability.AbilityType.Bomb:
			bomb.visible = true
		Ability.AbilityType.Lazer:
			lazer.visible = true

func _physics_process(delta: float) -> void:
	var currentDevice = player.CurrentDevice
	change_ability_buttons(currentDevice)
	if currentDevice == "keyboard":
		joystick.texture = move_mouse_texture
		if player.playerMovement.length() > 0:
			joystick.position = (player.playerMovement).normalized() * move_multi
		else:
			joystick.position = Vector2.ZERO
	else:
		joystick.texture = move_joystick_texture
		joystick.position = player.playerMovement * move_multi

func change_ability_buttons(_currentDevice:String):
	if _currentDevice == "keyboard":
		burst_button.texture = button_burst_Keyboard
		bomb_button.texture = button_bomb_Keyboard
		barrage_button.texture = button_barrage_Keyboard
		lazer_button.texture = button_lazer_Keyboard
	else:
		burst_button.texture = button_burst_controller
		bomb_button.texture = button_bomb_controller
		barrage_button.texture = button_barrage_controller
		lazer_button.texture = button_lazer_controller
