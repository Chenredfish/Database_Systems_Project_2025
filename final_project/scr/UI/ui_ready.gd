extends Control

signal skill_choose(number:int)
signal ring_choose(number:int)
signal equipment_choose(equipments_index:int)
signal next_wave
signal to_show_ring(aim:String)

@onready var equipment_list = $MarginContainer/HBoxContainer/character/character/equipment_list

func input_show_equipment_data(equipments:Array):
	equipment_list.input_show_equipment_data(equipments)
	


func _on_previous_page_btn_pressed():
	equipment_list._page_change(-1)


func _on_next_page_btn_pressed():
	equipment_list._page_change(1)


func _on_line_edit_text_submitted(new_text):
	equipment_list._search_equipment(new_text)


func _on_ring_list_ring_choose(number: int) -> void:
	ring_choose.emit(number)


func _on_skill_list_skill_choose(number: int) -> void:
	skill_choose.emit(number)


func _on_equipment_list_equipment_choose(equipments_index: int) -> void:
	equipment_choose.emit(equipments_index)


func _on_next_wave_btn_pressed():
	next_wave.emit()

func _on_show_ring_btn_pressed():
	to_show_ring.emit('player')
