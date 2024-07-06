class_name AbilityButton
extends Control

@onready var name_text = %NameText
@onready var ability_type_text = %AbilityTypeText
@onready var description_text = %DescriptionText

var Name:String = "Placeholder":
	set(newValue):
		name = newValue
		name_text.text = newValue

var abilityType:Ability.AbilityType = Ability.AbilityType.Burst:
	set(newValue):
		match newValue:
			Ability.AbilityType.Burst:
				abilityType = Ability.AbilityType.Burst
				ability_type_text.text = "Burst"
			Ability.AbilityType.Bomb:
				abilityType = Ability.AbilityType.Bomb
				ability_type_text.text = "Bomb"
			Ability.AbilityType.Barrage:
				abilityType = Ability.AbilityType.Barrage
				ability_type_text.text = "Barrage"
			Ability.AbilityType.Lazer:
				abilityType = Ability.AbilityType.Lazer
				ability_type_text.text = "Beam"

var Description:String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit est.":
	set(newValue):
		Description = newValue
		description_text.text = newValue
