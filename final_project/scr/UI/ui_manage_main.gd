extends Control

signal exit_btn_pressed
signal manage_ring_btn_pressed
signal to_manage_something(aim:String)

func _on_exit_button_pressed():
	exit_btn_pressed.emit()



func _to_manage_ring_button_pressed():
	manage_ring_btn_pressed.emit()


func _to_manage_skill_button_pressed():
	to_manage_something.emit('skill')


func _to_manage_equipment_button_pressed():
	to_manage_something.emit('equipment')


func _to_manage_actor_button_pressed():
	to_manage_something.emit('actor')

func _to_manage_record_button_pressed():
	to_manage_something.emit('record')
