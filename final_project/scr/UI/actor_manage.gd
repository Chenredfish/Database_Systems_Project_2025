extends MarginContainer
signal refresh_database

@onready var actor_id = $HBC/actor_id/LineEdit
@onready var actor_name = $HBC/actor_name/LineEdit
@onready var actor_level = $HBC/actor_level/LineEdit
@onready var actor_element = $HBC/actor_element
@onready var actor_health = $HBC/actor_health/LineEdit
@onready var actor_attack_point = $HBC/actor_attack_point/LineEdit
@onready var actor_magic_point = $HBC/actor_magic_point/LineEdit
@onready var actor_attack_defence = $HBC/actor_attack_defence/LineEdit
@onready var actor_magic_defence = $HBC/actor_magic_defence/LineEdit
@onready var db = SQLite.new()
@onready var actor_list = $"../actor_list/actor_list"
var element_id_array = ["火", "水", "草", "光", "暗"]

func _ready():
	actor_list.actor_edit.connect(actor_set)
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

func _on_actor_manage_btn_pressed() -> void:
	pass
	#var sql = "SELECT * FROM ring WHERE id = ?"
	#db.query_with_bindings(sql,[str(actor_id.text)])
	#var add_or_change = db.query_result
	#print(add_or_change)
	#if add_or_change.size() > 0:
		#print("change")
		#actor_change()
	#else:
		#print("add")
		#actor_add()

func actor_change():
	var data = {
		"name":actor_name.text,
		"level":actor_level.text,
		"element":actor_element.get_item_text(actor_element.get_selected_id()),
		"health":actor_health.text,
		"attack_point":actor_attack_point.text,
		"magic_point":actor_magic_point.text,
		"attack_defence":actor_attack_defence.text,
		"magic_defence":actor_magic_defence.text
	}
	db.update_rows("actor", "id = '" + actor_id.text + "'", data)
	refresh_database.emit()

func actor_add():
	var data = {
		"id":actor_id.text,
		"name":actor_name.text,
		"level":actor_level.text,
		"element":actor_element.get_item_text(actor_element.get_selected_id()),
		"health":actor_health.text,
		"attack_point":actor_attack_point.text,
		"magic_point":actor_magic_point.text,
		"attack_defence":actor_attack_defence.text,
		"magic_defence":actor_magic_defence.text
	}
	db.insert_row("actor", data)
	refresh_database.emit()

func actor_set(actor_data:Dictionary):
	actor_id.text = str(actor_data["id"])
	actor_name.text = str(actor_data["name"])
	actor_level.text = str(actor_data["level"])
	for id in range(element_id_array.size()):
		if element_id_array[id] == str(actor_data["element"]):
			actor_element.select(id)
	actor_health.text = str(actor_data["health"])
	actor_attack_point.text = str(actor_data["attack_point"])
	actor_magic_point.text = str(actor_data["magic_point"])
	actor_attack_defence.text = str(actor_data["attack_defence"])
	actor_magic_defence.text = str(actor_data["magic_defence"])
