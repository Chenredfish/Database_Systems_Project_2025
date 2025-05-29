extends Control

signal exit_show_ring

@onready var ring: GridContainer = $MarginContainer/HBoxContainer/ring_list/VBoxContainer/MarginContainer/ring

@onready var actor_data = $MarginContainer/HBoxContainer/character_status/actor_data


func _on_exit_button_pressed():
	exit_show_ring.emit()

func input_show_ring_data(actor:Actor):
	ring.input_show_ring_data(actor)
	show_actor_data(actor)

func delete_show_ring_data():
	ring.delete_show_ring_data()

func show_actor_data(actor:Actor):
	actor_data.show_actor_data(actor)


func _on_previous_page_btn_pressed():
	ring._page_change(-1)

func _on_next_page_btn_pressed():
	ring._page_change(1)

func _on_line_edit_text_submitted(new_text):
	ring._search_ring(new_text)
