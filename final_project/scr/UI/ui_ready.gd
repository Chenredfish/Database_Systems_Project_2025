extends Control

@onready var equipment_list = $MarginContainer/HBoxContainer/character/character/equipment_list

func input_show_equipment_data(actor:Actor):
	equipment_list.input_show_equipment_data(actor)
