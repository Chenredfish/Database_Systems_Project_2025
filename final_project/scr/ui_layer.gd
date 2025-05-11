extends CanvasLayer

@onready var ui_manage_change = $UiManageChange
@onready var ui_manage_change_ring = $UiManageChangeRing
@onready var ui_manage_main = $UiManageMain
@onready var ui_playing = $UiPlaying
@onready var ui_ready = $UiReady
@onready var ui_show_ring = $UiShowRing

signal exit_playing
signal exit_manage_main
signal exit_manage_change_ring
signal to_manage_ring
signal to_manage_something(aim:String)

#開關UI的函式
func show_ui_manage_change():
	ui_manage_change.show()
	
func hide_ui_manage_change():
	ui_manage_change.hide()
	
func show_ui_manage_change_ring():
	ui_manage_change_ring.show()
	
func hide_ui_manage_change_ring():
	ui_manage_change_ring.hide()

func show_ui_manage_main():
	ui_manage_main.show()
	
func hide_ui_manage_main():
	ui_manage_main.hide()
	
func show_ui_playing():
	ui_playing.show()
	
func hide_ui_playing():
	ui_playing.hide()
	
func show_ui_ready():
	ui_ready.show()
	
func hide_ui_ready():
	ui_ready.hide()
	
func show_ui_show_ring():
	ui_show_ring.show()
	
func hide_ui_show_ring():
	ui_show_ring.hide()

#管理按鈕按下
func _on_ui_playing_exit_btn_pressed():
	exit_playing.emit()

func _on_ui_manage_main_exit_btn_pressed():
	exit_manage_main.emit()

func _on_ui_manage_change_ring_exit_btn_pressed():
	exit_manage_change_ring.emit()

func _on_ui_manage_main_manage_ring_btn_pressed():
	to_manage_ring.emit()

func _on_ui_manage_main_to_manage_something(aim):
	to_manage_something.emit(aim)
