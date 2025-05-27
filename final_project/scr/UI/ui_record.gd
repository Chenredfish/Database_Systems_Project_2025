extends Control

signal exit_btn_pressed

func _on_exit_button_pressed():
	exit_btn_pressed.emit()
