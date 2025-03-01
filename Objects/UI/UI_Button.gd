@tool
class_name UI_Button
extends Button

var sfx_button_down: AudioStreamPlayer:
	set(newValue):
		sfx_button_down = newValue
		set_sfx_button(sfx_button_down)
		sfx_button_down.stream = SFX_Pressed
var sfx_button_release: AudioStreamPlayer:
	set(newValue):
		sfx_button_release = newValue
		set_sfx_button(sfx_button_release)
		#sfx_button_release.stream = SFX_Released
var sfx_button_hover_focus: AudioStreamPlayer:
	set(newValue):
		sfx_button_hover_focus = newValue
		set_sfx_button(sfx_button_hover_focus)
		sfx_button_hover_focus.stream = SFX_Hovered

@export var SFX_Pressed:AudioStream = preload("res://Audio/UI/Menu Button press_sfx_Ver2 Short.mp3")
#@export var SFX_Released:AudioStream = preload("res://Audio/Free Assets/SFX/interfaceanditemsounds/V.3.0 Files/Click (14).wav")
@export var SFX_Hovered:AudioStream = preload("res://Audio/UI/Menu Option hover sound_sfx.wav")
@export var Audio_mix_target:AudioStreamPlayer.MixTarget = AudioStreamPlayer.MIX_TARGET_CENTER
@export var Audio_bus:String = "Menu_Button"
@export var Focus_ready:bool = false
@export var Disable_on_pressed:bool = false

func _init() -> void:
	theme = preload("res://Art/new_theme.tres")

signal Pressed_button
signal Initial_Pressed_button
signal Released_button
signal Hovered_button

func _on_resource_changed() -> void:
	print("My resource just changed!")

func set_sfx_button(_new_button:AudioStreamPlayer) -> void:
	add_child(_new_button)
	_new_button.mix_target = Audio_mix_target
	_new_button.bus = Audio_bus

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sfx_button_down = AudioStreamPlayer.new()
	sfx_button_release = AudioStreamPlayer.new()
	sfx_button_hover_focus = AudioStreamPlayer.new()
	
	if Focus_ready: grab_focus()
	
	pressed.connect(_play_button_down)
	
	button_up.connect(_play_button_up)
	
	focus_entered.connect(_play_button_hover_focus)
	mouse_entered.connect(_play_button_hover_focus)

#region Pressed / Button Down
func _play_button_down() -> void:
	disabled = Disable_on_pressed
	sfx_button_down.play()
	Initial_Pressed_button.emit()
	await sfx_button_down.finished
	Pressed_button.emit()
#endregion

#region Released / Button Up
func _play_button_up() -> void:
	sfx_button_release.play()
	await sfx_button_release.finished
	Released_button.emit()
#endregion

#region Focus / Hover
func _play_button_hover_focus() -> void:
	sfx_button_hover_focus.play()
	await sfx_button_hover_focus.finished
	Hovered_button.emit()
#endregion
