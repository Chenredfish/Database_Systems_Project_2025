extends Control

signal exit_btn_pressed
signal next_page_pressed
signal previous_page_pressed

@onready var db = SQLite.new()

func _ready():
	db.path = "res://data/game"
	db.open_db()

func _on_exit_button_pressed():
	exit_btn_pressed.emit()

func _on_next_page_btn_pressed() -> void:
	pass

func _on_previous_page_btn_pressed() -> void:
	pass # Replace with function body.
