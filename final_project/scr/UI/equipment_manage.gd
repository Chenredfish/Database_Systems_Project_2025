extends MarginContainer

signal refresh_database

@onready var equipment_id = $HBC/equipment_id/LineEdit
@onready var equipment_name = $HBC/equipment_name/LineEdit
@onready var equipment_level = $HBC/equipment_level/LineEdit
@onready var equipment_attack_defence = $HBC/equipment_attack_defence/LineEdit
@onready var equipment_magic_defence = $HBC/equipment_magic_defence/LineEdit
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
	
func _on_equipment_manage_btn_pressed() -> void:
	pass
	#var sql = "SELECT * FROM equipment WHERE id = ?"
	#db.query_with_bindings(sql,[str(equipment_id.text)])
	#var add_or_change = db.query_result
	#print(add_or_change)
	#if add_or_change.size() > 0:
		#print("change")
		#skill_change()
	#else:
		#print("add")
		#skill_add()

func skill_change():
	var data = {
		"name":equipment_name.text,
		"level":equipment_level.text,
		"attack_defence":equipment_attack_defence.text,
		"magic_defence":equipment_magic_defence.text,
	}
	db.update_rows("equipment", "id = '" + equipment_id.text + "'", data)
	refresh_database.emit()

func skill_add():
	var data = {
		"id":equipment_id.text,
		"name":equipment_name.text,
		"level":equipment_level.text,
		"attack_defence":equipment_attack_defence.text,
		"magic_defence":equipment_magic_defence.text,
	}
	db.insert_row("equipment", data)
	refresh_database.emit()
