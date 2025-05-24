extends Control

signal refresh_database
signal exit_btn_pressed

@onready var equipment_list = $MC/VBC/equipment_list/equipment_list
@onready var db = SQLite.new()
@onready var equipment_search = $MC/VBC/switch_pages/HBC/equipment_search/LineEdit

func _ready():
	db.path = "res://data/game"
	db.open_db()
	refresh_database.connect(equipment_list._refresh_db)

func _on_exit_button_pressed():
	exit_btn_pressed.emit()

func _on_previous_page_btn_pressed() -> void:
	equipment_list._page_change(-1)

func _on_next_page_btn_pressed() -> void:
	equipment_list._page_change(1)

func _on_equipment_search_text_submitted(new_text: String) -> void:
	equipment_list._search_ring(equipment_search.text)
