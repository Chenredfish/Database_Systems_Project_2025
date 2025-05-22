extends Control

@onready var pause = $pause/pause
const PAUSE_SQUARE_BUTTON = preload("res://assets/Menu Buttons/Square Buttons/Square Buttons/Pause Square Button.png")
const PLAY_SQUARE_BUTTON = preload("res://assets/Menu Buttons/Square Buttons/Square Buttons/Play Square Button.png")

signal exit_btn_pressed
signal pause_btn_pressed
signal show_ring_btn_pressed(aim:String)

func _ready():
	pause.expand_icon = true
	pause.set("icon", PAUSE_SQUARE_BUTTON)

func _on_button_button_down():
	exit_btn_pressed.emit()


func _on_pause_pressed():
	pause_btn_pressed.emit()
	if pause.get("icon") == PAUSE_SQUARE_BUTTON:
		pause.set("icon", PLAY_SQUARE_BUTTON)
	else:
		pause.set("icon", PAUSE_SQUARE_BUTTON)

func _on_player_data_button_pressed():
	show_ring_btn_pressed.emit("player")

func _on_enemy_data_button_pressed():
	show_ring_btn_pressed.emit("enemy")
