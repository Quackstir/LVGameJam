extends Control

@export var abilityResources:Array[AbilityResource]

@export var ability_button:Array[AbilityButton] 

func _ready():
	setAbilityButtons(abilityResources[randi_range(0,abilityResources.size() - 1)],0)
	setAbilityButtons(abilityResources[randi_range(0,abilityResources.size() - 1)],1)

func setAbilityButtons(ability:AbilityResource, index:int):
	ability_button[index].Name = ability.Name
	ability_button[index].abilityType = ability.Type
	ability_button[index].Description = ability.Description
