extends Control

signal exit_btn_pressed

@onready var actor_list = $MC/VBC/actor_list/actor_list
@onready var db = SQLite.new()
@onready var actor_search = $MC/VBC/switch_pages/HBC/actor_search/actor_search

func _ready():
	db.path = "res://data/game"
	db.open_db()

func _on_exit_button_pressed():
	exit_btn_pressed.emit()

func _on_previous_page_btn_pressed() -> void:
	actor_list._page_change(-1)

func _on_next_page_btn_pressed() -> void:
	actor_list._page_change(1)

func _on_actor_search_text_submitted(new_text: String) -> void:
	actor_list._search_ring(actor_search.text)
