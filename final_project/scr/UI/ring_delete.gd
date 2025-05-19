extends VBoxContainer
class_name ring

@onready var db = SQLite.new()

func _ready():
	db.path = "res://data/game"
	db.open_db()

func _on_button_pressed() -> void:
	remove_child(self)
	self.queue_free()
#	db.delete_rows("ring", "id = '" + ring_id.text + "'")
