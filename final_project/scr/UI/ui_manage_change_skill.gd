extends Control

signal exit_btn_pressed
signal refresh_database

@onready var db = SQLite.new()


@onready var id_input = $MarginContainer/VBoxContainer/skill_manage/skill_status/HBoxContainer/skill_id/LineEdit
@onready var name_input = $MarginContainer/VBoxContainer/skill_manage/skill_status/HBoxContainer/skill_name/LineEdit
@onready var level_input = $MarginContainer/VBoxContainer/skill_manage/skill_status/HBoxContainer/skill_level/LineEdit
@onready var element_input = $MarginContainer/VBoxContainer/skill_manage/skill_status/HBoxContainer/skill_element/LineEdit
@onready var is_magic_input = $MarginContainer/VBoxContainer/skill_manage/skill_status/HBoxContainer/skill_is_magic/LineEdit
@onready var power_input = $MarginContainer/VBoxContainer/skill_manage/skill_status/HBoxContainer/skill_power/LineEdit
@onready var cooldown_input = $MarginContainer/VBoxContainer/skill_manage/skill_status/HBoxContainer/skill_cooldown/LineEdit
@onready var apply_button = $MarginContainer/VBoxContainer/skill_manage/skill_status/HBoxContainer/skill_manage/skill_manage_btn

@onready var skill_list = $MarginContainer/VBoxContainer/skill_list/skill_list
@onready var skill_search = $MarginContainer/VBoxContainer/switch_pages/HBoxContainer/skill_search/skill_search

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

func _on_exit_button_pressed():
	exit_btn_pressed.emit()

func _on_next_page_btn_pressed() -> void:
	skill_list._page_change(1)

func _on_previous_page_btn_pressed() -> void:
	skill_list._page_change(-1)

func _on_skill_search_text_submitted() -> void:
	skill_list._search_skill(skill_search.text)


	var id = id_input.text.strip_edges()
	var skill_name = name_input.text.strip_edges()
	var level = level_input.text.strip_edges()
	var element = element_input.text.strip_edges()
	var is_magic = is_magic_input.text.strip_edges()
	if is_magic == "魔法":
		is_magic = "1"
	elif is_magic == "物理":
		is_magic = "0"
	else:
		await show_alert("⚠️ is_magic 只能輸入『物理』或『魔法』")
		return
	var power = power_input.text.strip_edges()
	var cooldown = cooldown_input.text.strip_edges()

	# 檢查所有欄位是否填寫
	if [id, skill_name, level, element, is_magic, power, cooldown].has(""):
		await show_alert("❗請填寫所有欄位")
		return

	# ID 必須為整數且大於 0
	if not id.is_valid_int():
		await show_alert("⚠️ ID 必須為整數")
		return
	var id_val = int(id)
	if id_val <= 0:
		await show_alert("⚠️ ID 必須大於 0")
		return

	# level 必須為整數
	if not level.is_valid_int():
		await show_alert("⚠️ level 必須為整數")
		return
	if not is_magic.is_valid_int():
		await show_alert("⚠️ is_magic 必須是 物理(0) 或 魔法(1)")
		return
	# cooldown 必須為小數
	if not cooldown.is_valid_float():
		await show_alert("⚠️ cooldown 必須為小數")
		return
	# power 必須為小數
	if not power.is_valid_float():
		await show_alert("⚠️ 攻擊係數必須為小數")
		return

	var lv = int(level)
	var magic = int(is_magic)
	var cd = float(cooldown)
	var pw = float(power)

	if lv < 0:
		await show_alert("⚠️ level 需為非負整數")
		return
	if magic != 0 and magic != 1:
		await show_alert("⚠️ is_magic 必須是 物理(0) 或 魔法(1)")
		return
	if cd <= 1.0:
		await show_alert("⚠️ cooldown 必須為大於 1 的小數")
		return
	if pw <= 1.0:
		await show_alert("⚠️ power 必須為大於 1 的小數")
		return

	# 名稱唯一性檢查（排除自己）
	db.query("SELECT COUNT(*) as count FROM skill WHERE name = '" + skill_name + "' AND id != " + str(id_val))
	var result = db.query_result
	if result.size() > 0 and result[0].has("count") and int(result[0]["count"]) > 0:
		await show_alert("❌ 名稱已存在")
		return

	# element 必須存在
	db.query("SELECT COUNT(*) as count FROM element WHERE name = '" + element + "'")
	result = db.query_result
	if result.size() == 0 or not result[0].has("count") or int(result[0]["count"]) == 0:
		await show_alert("❌ 所選 element 不存在")
		return

	# 判斷是 UPDATE 還是 INSERT
	db.query("SELECT COUNT(*) as count FROM skill WHERE id = " + str(id_val))
	result = db.query_result
	if result.size() > 0 and result[0].has("count") and int(result[0]["count"]) > 0:
		# ID 已存在，執行 UPDATE
		db.query("UPDATE skill SET name = '" + skill_name + "', level = " + str(lv) + ", element = '" + element + "', is_magic = " + str(magic) + ", power = " + str(pw) + ", cooldown = " + str(cd) + " WHERE id = " + str(id_val))
	else:
		# ID 不存在，執行 INSERT
		db.query("INSERT INTO skill (id, name, level, element, is_magic, power, cooldown) VALUES (" + str(id_val) + ", '" + skill_name + "', " + str(lv) + ", '" + element + "', " + str(magic) + ", " + str(pw) + ", " + str(cd) + ")")

	refresh_database.emit()
	show_alert("✅ 資料已儲存")
	skill_list.refresh()

func show_alert(msg: String):
	var dialog = AcceptDialog.new()
	dialog.dialog_text = msg
	add_child(dialog)
	dialog.popup_centered()

func _on_skill_manage_btn_pressed() -> void:
	_on_skill_search_text_submitted()
 


func _on_skill_list_show_alert(msg):
	show_alert(msg)
