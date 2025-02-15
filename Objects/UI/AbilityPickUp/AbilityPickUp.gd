class_name AbilityPickUp
extends Control

@export var abilityResources:Array[AbilityResource]
var getAbilityResources:Array[AbilityResource]

@export var ability_button:Array[AbilityButton] 
var selectedAbilityResource:Ability.AbilityType

var GameManager:GM

func _ready():
	for button in ability_button:
		button.GameManager = GameManager
		updateAbilityButtons()

func updateAbilityButtons() -> void:
	getAbilityResources.assign(abilityResources)
	
	var a = randi_range(0,getAbilityResources.size() - 1)
	setAbilityButtons(getAbilityResources[a],0)
	getAbilityResources.remove_at(a)
	
	var b = randi_range(0,getAbilityResources.size() - 1)
	setAbilityButtons(getAbilityResources[b],1)
	getAbilityResources.remove_at(b)
	
	ability_button[0].button.grab_focus()

func setAbilityButtons(ability:AbilityResource, index:int):
	ability_button[index].Name = ability.Name
	ability_button[index].abilityType = ability.Type
	ability_button[index].Description = ability.Description
	ability_button[index].assignedAbility = ability

func _on_ability_button_selected_ability():
	selectedAbilityResource = ability_button[0].assignedAbility.Type
	selectedAbility()

func _on_ability_button_2_selected_ability():
	selectedAbilityResource = ability_button[1].assignedAbility.Type
	selectedAbility()
	
func selectedAbility():
	for i in abilityResources.size()-1:
		if abilityResources[i].Type == selectedAbilityResource:
			abilityResources.remove_at(i)
	visible = false
