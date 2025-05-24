extends MarginContainer

@onready var db = SQLite.new()

func _ready():
	db.path = "res://data/game"
	db.open_db()
