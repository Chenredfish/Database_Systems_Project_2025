extends Control

signal exit_btn_pressed

@onready var skill_list = $MarginContainer/VBoxContainer/skill_list/skill_list
@onready var db = SQLite.new()

func _ready():
	db.path = "res://data/game"
	db.open_db()

func _on_exit_button_pressed():
	exit_btn_pressed.emit()

func _on_next_page_btn_pressed() -> void:
	skill_list._page_change(1)

func _on_previous_page_btn_pressed() -> void:
	skill_list._page_change(-1)
