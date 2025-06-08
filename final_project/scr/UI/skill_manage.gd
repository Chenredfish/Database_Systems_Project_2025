extends MarginContainer

signal refresh_database

@onready var skill_id = $skill_status/HBoxContainer/skill_id/LineEdit
@onready var skill_name = $skill_status/HBoxContainer/skill_name/LineEdit
@onready var skill_level = $skill_status/HBoxContainer/skill_level/LineEdit
@onready var skill_element = $skill_status/HBoxContainer/skill_element
@onready var skill_is_magic = $skill_status/HBoxContainer/skill_is_magic/LineEdit
@onready var skill_power = $skill_status/HBoxContainer/skill_power/LineEdit
@onready var skill_cooldown = $skill_status/HBoxContainer/skill_cooldown/LineEdit
@onready var db = SQLite.new()
@onready var skill_list = $"../skill_list/skill_list"
var element_id_array = ["火", "水", "草", "光", "暗"]

func _ready():
	skill_list.skill_edit.connect(skill_set)
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
	
func _on_skill_manage_btn_pressed() -> void:
	
	pass

	#var sql = "SELECT * FROM skill WHERE id = ?"
	#db.query_with_bindings(sql,[str(skill_id.text)])
	#var add_or_change = db.query_result
	#print(add_or_change)
	#if add_or_change.size() > 0:
		#print("change")
		#skill_change()
	#else:
		#print("add")
		#skill_add()
		#

func skill_change():
	var data = {
		"name":skill_name.text,
		"level":skill_level.text,
		"element":skill_element.get_item_text(skill_element.get_selected_id()),
		"is_magic":skill_is_magic.text,
		"power":skill_power.text,
		"cooldown":skill_cooldown.text,
	}
	db.update_rows("skill", "id = '" + skill_id.text + "'", data)
	refresh_database.emit()

func skill_add():
	var data = {
		"id":skill_id.text,
		"name":skill_name.text,
		"level":skill_level.text,
		"element":skill_element.get_item_text(skill_element.get_selected_id()),
		"is_magic":skill_is_magic.text,
		"power":skill_power.text,
		"cooldown":float(skill_cooldown.text),
	}
	db.insert_row("skill", data)
	refresh_database.emit()

func skill_set(skill_data:Dictionary):
	skill_id.text = str(skill_data["id"])
	skill_name.text = str(skill_data["name"])
	skill_level.text = str(skill_data["level"])
	for id in range(element_id_array.size()):
		if element_id_array[id] == str(skill_data["element"]):
			skill_element.select(id)
	if skill_data["is_magic"] == 0:
		skill_is_magic.text = "物理"
	elif  skill_data["is_magic"] == 1:
		skill_is_magic.text = "魔法"
	skill_power.text = str(skill_data["power"])
	skill_cooldown.text = str(skill_data["cooldown"])
