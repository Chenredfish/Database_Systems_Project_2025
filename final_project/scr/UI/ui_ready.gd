extends Control

@onready var equipment_list = $MarginContainer/HBoxContainer/character/character/equipment_list

func input_show_equipment_data(actor:Actor):
	equipment_list.input_show_equipment_data(actor)

func _on_previous_page_btn_pressed():
	equipment_list._page_change(-1)


func _on_next_page_btn_pressed():
	equipment_list._page_change(1)
