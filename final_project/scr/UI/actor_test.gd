extends MarginContainer

@onready var db = SQLite.new()

func _ready():
	db.path = "res://data/game"
	db.open_db()

func _on_button_pressed() -> void:
	remove_child(self)
	self.queue_free()
