extends MarginContainer

signal  ring_choose(number:int)

var UI_normal_theme = load("res://assets/UI_Theme.tres")
var UI_chosen_theme = load("res://assets/UI_chosen_theme.tres")

@onready var all_choose:Array[VBoxContainer] = [
	$HBoxContainer/ring1,
	$HBoxContainer/ring2,
	$HBoxContainer/ring3
]

func _update_ring_choose(number:int):
	for ring_child in all_choose:
		if ring_child.name == str("ring" + str(number)):
			ring_child.get_node("PanelContainer").theme = UI_chosen_theme
		else :
			ring_child.get_node("PanelContainer").theme = UI_normal_theme

func _on_ring_choose_1_pressed() -> void:
	ring_choose.emit(1)
	_update_ring_choose(1)


func _on_ring_choose_2_pressed() -> void:
	ring_choose.emit(2)
	_update_ring_choose(2)


func _on_ring_choose_3_pressed() -> void:
	ring_choose.emit(3)
	_update_ring_choose(3)
