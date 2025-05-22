extends Control

signal exit_btn_pressed
signal pause_btn_pressed
signal show_ring_btn_pressed(aim:String)

func _on_button_button_down():
	exit_btn_pressed.emit()


func _on_pause_pressed():
	pause_btn_pressed.emit()


func _on_player_data_button_pressed():
	show_ring_btn_pressed.emit("player")

func _on_enemy_data_button_pressed():
	show_ring_btn_pressed.emit("enemy")
