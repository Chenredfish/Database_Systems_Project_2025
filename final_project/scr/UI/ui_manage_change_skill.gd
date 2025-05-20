extends Control

signal exit_btn_pressed

@onready var skill_list = $MarginContainer/VBoxContainer/skill_list/skill_list
@onready var db = SQLite.new()
@onready var skill_search = $MarginContainer/VBoxContainer/switch_pages/HBoxContainer/skill_search/skill_search

func _ready():
	db.path = "res://data/game"
	db.open_db()

func _on_exit_button_pressed():
	exit_btn_pressed.emit()

func _on_next_page_btn_pressed() -> void:
	skill_list._page_change(1)

func _on_previous_page_btn_pressed() -> void:
	skill_list._page_change(-1)

func _on_skill_search_text_submitted(new_text: String) -> void:
	skill_list._search_skill(skill_search.text)
