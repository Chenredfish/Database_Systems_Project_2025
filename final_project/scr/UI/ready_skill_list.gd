extends MarginContainer

signal  skill_choose(number:int)

var UI_normal_theme = load("res://assets/UI_Theme.tres")
var UI_chosen_theme = load("res://assets/UI_chosen_theme.tres")

@onready var all_choose:Array[VBoxContainer] = [
	$HBoxContainer/skill1,
	$HBoxContainer/skill2,
	$HBoxContainer/skill3
]

func _update_ring_choose(number:int):
	for ring_child in all_choose:
		if ring_child.name == str("skill" + str(number)):
			ring_child.get_node("PanelContainer").theme = UI_chosen_theme
		else :
			ring_child.get_node("PanelContainer").theme = UI_normal_theme

func _on_skill_choose_1_pressed() -> void:
	_update_ring_choose(1)
	skill_choose.emit(1)


func _on_skill_choose_2_pressed() -> void:
	_update_ring_choose(2)
	skill_choose.emit(2)

func _on_skill_choose_3_pressed() -> void:
	_update_ring_choose(3)
	skill_choose.emit(3)
