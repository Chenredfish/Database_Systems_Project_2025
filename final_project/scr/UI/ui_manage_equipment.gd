extends Control

signal refresh_database
signal exit_btn_pressed
signal next_page_pressed

@onready var db = SQLite.new()

@onready var id_input = $MC/VBC/equipment_manage/HBC/equipment_id/LineEdit
@onready var name_input = $MC/VBC/equipment_manage/HBC/equipment_name/LineEdit
@onready var level_input = $MC/VBC/equipment_manage/HBC/equipment_level/LineEdit
@onready var attack_defence_input = $MC/VBC/equipment_manage/HBC/equipment_attack_defence/LineEdit
@onready var magic_defence_input = $MC/VBC/equipment_manage/HBC/equipment_magic_defence/LineEdit
@onready var apply_button = $MC/VBC/equipment_manage/HBC/equipment_manage/equipment_manage_btn

@onready var equipment_list = $MC/VBC/equipment_list/equipment_list
@onready var equipment_search = $MC/VBC/switch_pages/HBC/equipment_search

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
	refresh_database.connect(equipment_list._refresh_db)
	if apply_button and not apply_button.pressed.is_connected(_on_equipment_manage_btn_pressed):
		apply_button.pressed.connect(_on_equipment_manage_btn_pressed)

func _on_exit_button_pressed():
	exit_btn_pressed.emit()

func _on_previous_page_btn_pressed() -> void:
	equipment_list._page_change(-1)

func _on_next_page_btn_pressed() -> void:
	equipment_list._page_change(1)

func _on_equipment_search_text_submitted(new_text: String) -> void:
	equipment_list._search_ring(equipment_search.text)

func show_alert(msg: String):
	await get_tree().process_frame
	var dialog = AcceptDialog.new()
	dialog.dialog_text = msg
	add_child(dialog)
	dialog.popup_centered()


func _on_apply_pressed():
	var id = id_input.text.strip_edges()
	var name = name_input.text.strip_edges()
	var level = level_input.text.strip_edges()
	var attack_defence = attack_defence_input.text.strip_edges()
	var magic_defence = magic_defence_input.text.strip_edges()

	# 檢查所有欄位
	if [id, name, level, attack_defence, magic_defence].has(""):
		await show_alert("❗請填寫所有欄位")
		return

	# ID 必須為正整數
	if not id.is_valid_int():
		await show_alert("⚠️ ID 必須為整數")
		return
	var id_val = int(id)
	if id_val <= 0:
		await show_alert("⚠️ ID 必須大於 0")
		return

	# level 必須為非負整數
	if not level.is_valid_int():
		await show_alert("⚠️ level 必須為整數")
		return
	var lv = int(level)
	if lv < 0:
		await show_alert("⚠️ level 必須為非負整數")
		return

	# attack_defence 必須為正整數
	if not attack_defence.is_valid_int():
		await show_alert("⚠️ attack_defence 必須為整數")
		return
	var ad = int(attack_defence)
	if ad <= 0:
		await show_alert("⚠️ 物理防禦需為正整數")
		return

	# magic_defence 必須為正整數
	if not magic_defence.is_valid_int():
		await show_alert("⚠️ magic_defence 必須為整數")
		return
	var md = int(magic_defence)
	if md <= 0:
		await show_alert("⚠️ 魔法防禦需為正整數")
		return

	# 名稱不可重複（排除自己）
	db.query("SELECT COUNT(*) as count FROM equipment WHERE name = '" + name + "' AND id != " + str(id_val))
	var result = db.query_result
	if result.size() > 0 and result[0].has("count") and int(result[0]["count"]) > 0:
		await show_alert("❌ 名稱已存在")
		return

	# ID 是否已存在
	db.query("SELECT COUNT(*) as count FROM equipment WHERE id = " + str(id_val))
	result = db.query_result
	if result.size() > 0 and result[0].has("count") and int(result[0]["count"]) > 0:
		# ID 已存在，執行 UPDATE
		db.query("UPDATE equipment SET name = '" + name + "', level = " + str(lv) + ", attack_defence = " + str(ad) + ", magic_defence = " + str(md) + " WHERE id = " + str(id_val))
	else:
		# ID 不存在，執行 INSERT
		db.query("INSERT INTO equipment (id, name, level, attack_defence, magic_defence) VALUES (" + str(id_val) + ", '" + name + "', " + str(lv) + ", " + str(ad) + ", " + str(md) + ")")

	refresh_database.emit()
	await show_alert("✅ 資料已儲存")
	equipment_list._refresh_db()

func _on_equipment_manage_btn_pressed() -> void:
	_on_apply_pressed()
 


func _on_equipment_list_show_alert(msg):
	show_alert(msg)
