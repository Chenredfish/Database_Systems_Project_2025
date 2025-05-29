extends Control

signal exit_show_ring

@onready var ring: GridContainer = $MarginContainer/HBoxContainer/ring_list/VBoxContainer/MarginContainer/ring

@onready var actor_name = $MarginContainer/HBoxContainer/character_status/PanelContainer/MarginContainer/GridContainer/name
@onready var health = $MarginContainer/HBoxContainer/character_status/PanelContainer/MarginContainer/GridContainer/health
@onready var max_health = $MarginContainer/HBoxContainer/character_status/PanelContainer/MarginContainer/GridContainer/max_health
@onready var level = $MarginContainer/HBoxContainer/character_status/PanelContainer/MarginContainer/GridContainer/level
@onready var type = $MarginContainer/HBoxContainer/character_status/PanelContainer/MarginContainer/GridContainer/type
@onready var attack_power = $MarginContainer/HBoxContainer/character_status/PanelContainer/MarginContainer/GridContainer/attack_power
@onready var magic_power = $MarginContainer/HBoxContainer/character_status/PanelContainer/MarginContainer/GridContainer/magic_power
@onready var attack_defence = $MarginContainer/HBoxContainer/character_status/PanelContainer/MarginContainer/GridContainer/attack_defence
@onready var magic_defence = $MarginContainer/HBoxContainer/character_status/PanelContainer/MarginContainer/GridContainer/magic_defence


func _on_exit_button_pressed():
	exit_show_ring.emit()

func input_show_ring_data(actor:Actor):
	ring.input_show_ring_data(actor)
	show_actor_data(actor)

func delete_show_ring_data():
	ring.delete_show_ring_data()

func show_actor_data(actor:Actor):
	actor_name.text = str(actor.get('_name'))
	health.text = str(actor.get("health"))
	max_health.text = str(int(actor.get('max_health')))
	level.text = str(actor.get("level"))
	
	#取名錯誤，type已經改名為element
	type.text = str(actor.get("element"))
	#這裡有取名錯誤
	attack_power.text = str(actor.get("attack_point"))
	magic_power.text = str(actor.get("magic_point"))
	
	attack_defence.text = str(actor.get("attack_defence"))
	magic_defence.text = str(actor.get("magic_defence"))
	


func _on_previous_page_btn_pressed():
	ring._page_change(-1)

func _on_next_page_btn_pressed():
	ring._page_change(1)

func _on_line_edit_text_submitted(new_text):
	ring._search_ring(new_text)
