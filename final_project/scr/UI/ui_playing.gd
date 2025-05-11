extends Control

signal exit_btn_pressed

func _on_button_button_down():
	exit_btn_pressed.emit()
