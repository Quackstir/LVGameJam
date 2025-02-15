extends Node

@export_multiline var firstPage:String
@export_multiline var secondPage:String

@onready var switch_page: UI_Button = $"CanvasLayer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Switch Page"

@onready var rich_text_label: RichTextLabel = $CanvasLayer/Panel/MarginContainer/VBoxContainer/RichTextLabel
var isOnFirstPage:bool = true:
	set(newValue):
		isOnFirstPage = newValue
		if isOnFirstPage:
			rich_text_label.text = firstPage
			switch_page.text = "Page (1/2) | Next Page"
		else:
			rich_text_label.text = secondPage
			switch_page.text = "Page (2/2) | Previous Page"

func _ready() -> void:
	switch_page.grab_focus()

func _on_back_pressed_button() -> void:
	get_tree().change_scene_to_file("res://Levels/menu.tscn")


func _on_switch_page_pressed_button() -> void:
	isOnFirstPage = !isOnFirstPage
