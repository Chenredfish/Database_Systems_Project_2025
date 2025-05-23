extends CanvasLayer

@onready var ui_manage_change = $UiManageChange
@onready var ui_manage_change_ring = $UiManageChangeRing
@onready var ui_manage_main = $UiManageMain
@onready var ui_playing = $UiPlaying
@onready var ui_ready = $UiReady
@onready var ui_show_ring = $UiShowRing
@onready var ui_manage_change_actor = $UIManageChangeActor
@onready var ui_manage_change_skill = $UiManageChangeSkill

signal exit_playing
signal exit_manage_main
signal exit_manage_change_ring
signal exit_manage_change_something
signal exit_show_ring
signal to_manage_ring
signal to_manage_something(aim:String)
signal to_show_ring(aim:String)
signal to_pause

#輸入資料給show_ring顯示
func input_show_ring_data(actor:Actor):
	ui_show_ring.input_show_ring_data(actor)

#設定暫停按鈕回到暫停畫面
func set_pause_btn_to_pause():
	ui_playing.set_pause_btn_to_pause()

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
	ui_show_ring.delete_show_ring_data()
	
func show_ui_manage_change_actor():
	ui_manage_change_actor.show()

func hide_ui_manage_change_actor():
	ui_manage_change_actor.hide()
	
func show_ui_manage_change_skill():
	ui_manage_change_skill.show()

func hide_ui_manage_change_skill():
	ui_manage_change_skill.hide()

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

func _on_ui_playing_pause_btn_pressed():
	to_pause.emit()

func _on_ui_show_ring_exit_show_ring():
	exit_show_ring.emit()

func _on_ui_playing_show_ring_btn_pressed(aim):
	to_show_ring.emit(aim)

func _on_ui_manage_change_actor_exit_btn_pressed():
	exit_manage_change_something.emit()

func _on_ui_manage_change_skill_exit_btn_pressed():
	exit_manage_change_something.emit()
