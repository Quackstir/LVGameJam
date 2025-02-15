class_name AbilityButton
extends Control

@onready var name_text = %NameText
@onready var description_text = %DescriptionText
var assignedAbility:AbilityResource

var GameManager:GM

signal selectedAbility
@onready var button: Button = $Button

@onready var ability_type_texture: TextureRect = %AbilityTypeTexture

@export var buttonTexture_Down:Texture
@export var buttonTexture_Up:Texture
@export var buttonTexture_Right:Texture
@export var buttonTexture_Left:Texture

var Name:String = "Placeholder":
	set(newValue):
		name = newValue
		name_text.text = newValue

var abilityType:Ability.AbilityType = Ability.AbilityType.Burst:
	set(newValue):
		match newValue:
			Ability.AbilityType.Burst:
				abilityType = Ability.AbilityType.Burst
				#ability_type_text.text = "Burst"
				ability_type_texture.texture = buttonTexture_Down
			Ability.AbilityType.Bomb:
				abilityType = Ability.AbilityType.Bomb
				#ability_type_text.text = "Bomb"
				ability_type_texture.texture = buttonTexture_Left
			Ability.AbilityType.Barrage:
				abilityType = Ability.AbilityType.Barrage
				#ability_type_text.text = "Barrage"
				ability_type_texture.texture = buttonTexture_Up
			Ability.AbilityType.Lazer:
				abilityType = Ability.AbilityType.Lazer
				#ability_type_text.text = "Beam"
				ability_type_texture.texture = buttonTexture_Right

var Description:String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit est.":
	set(newValue):
		Description = newValue
		description_text.text = newValue

func _on_button_pressed_button() -> void:
	GameManager.player.addAbility(assignedAbility)
	selectedAbility.emit()
	get_tree().paused = false
