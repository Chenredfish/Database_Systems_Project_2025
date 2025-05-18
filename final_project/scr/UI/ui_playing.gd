extends Control

signal exit_btn_pressed
signal pause_btn_pressed

func _on_button_button_down():
	exit_btn_pressed.emit()


func _on_pause_pressed():
	pause_btn_pressed.emit()
