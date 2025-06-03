extends VBoxContainer
class_name ring

@onready var db = SQLite.new()

func _ready():
	var db_dir = "user://data"
	var db_path = db_dir + "/game.db"
	# 確保 user://data 資料夾存在
	if not DirAccess.dir_exists_absolute(db_dir):
		DirAccess.make_dir_recursive_absolute(db_dir)
	# 如果 user://data/game.db 不存在，從 res://data/game.db 複製過去
	if not FileAccess.file_exists(db_path):
		var src = FileAccess.open("res://data/game.db", FileAccess.READ)
		var dst = FileAccess.open(db_path, FileAccess.WRITE)
		dst.store_buffer(src.get_buffer(src.get_length()))
		src.close()
		dst.close()
	db.path = db_path
	db.open_db()

func _on_button_pressed() -> void:
	remove_child(self)
	self.queue_free()
#	db.delete_rows("ring", "id = '" + ring_id.text + "'")
