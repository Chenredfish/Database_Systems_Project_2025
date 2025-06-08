extends MarginContainer

@onready var ring_id = $ring_status/HBoxContainer/ring_id/LineEdit
@onready var ring_name = $ring_status/HBoxContainer/ring_name/LineEdit
@onready var ring_level = $ring_status/HBoxContainer/ring_level/LineEdit
@onready var ring_health = $ring_status/HBoxContainer/ring_health/LineEdit
@onready var ring_attack_power = $ring_status/HBoxContainer/ring_attack_power/LineEdit
@onready var ring_magic_power =$ring_status/HBoxContainer/ring_magic_power/LineEdit
@onready var ring_attack_defence =$ring_status/HBoxContainer/ring_attack_defence/LineEdit
@onready var ring_magic_defence =$ring_status/HBoxContainer/ring_magic_defence/LineEdit
@onready var db = SQLite.new()
@onready var list = $"../ring_list/list"

func _ready():
	list.ring_edit.connect(ring_set)
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
	
func _on_ring_manage_btn_pressed():
	pass
	#var sql = "SELECT * FROM ring WHERE id = ?"
	#db.query_with_bindings(sql,[str(ring_id.text)])
	#var add_or_change = db.query_result
	#print(add_or_change)
	#if add_or_change.size() > 0:
		#print("change")
		#ring_change()
	#else:
		#print("add")
		#ring_add()

func ring_change():
	var data = {
		"name":ring_name.text,
		"level":ring_level.text,
		"health":ring_health.text,
		"attack_power":ring_attack_power.text,
		"magic_power":ring_magic_power.text,
		"attack_defence":ring_attack_defence.text,
		"magic_defence":ring_magic_defence.text
	}
	db.update_rows("ring", "id = '" + ring_id.text + "'", data)

func ring_add():
	var data = {
		"id":ring_id.text,
		"name":ring_name.text,
		"level":ring_level.text,
		"health":ring_health.text,
		"attack_power":ring_attack_power.text,
		"magic_power":ring_magic_power.text,
		"attack_defence":ring_attack_defence.text,
		"magic_defence":ring_magic_defence.text
	}
	db.insert_row("ring", data)

func ring_set(ring_data:Dictionary):
	ring_id.text = str(ring_data["id"])
	ring_name.text = str(ring_data["name"])
	ring_level.text = str(ring_data["level"])
	ring_health.text = str(ring_data["health"])
	ring_attack_power.text = str(ring_data["attack_power"])
	ring_magic_power.text = str(ring_data["magic_power"])
	ring_attack_defence.text = str(ring_data["attack_defence"])
	ring_magic_defence.text = str(ring_data["magic_defence"])
