extends Control

signal refresh_database
signal exit_btn_pressed

@onready var db = SQLite.new()

@onready var id_input = $MC/VBC/actor_manage/HBC/actor_id/LineEdit
@onready var name_input = $MC/VBC/actor_manage/HBC/actor_name/LineEdit
@onready var level_input = $MC/VBC/actor_manage/HBC/actor_level/LineEdit
@onready var health_input = $MC/VBC/actor_manage/HBC/actor_health/LineEdit
@onready var attack_point_input = $MC/VBC/actor_manage/HBC/actor_attack_point/LineEdit
@onready var magic_point_input = $MC/VBC/actor_manage/HBC/actor_magic_point/LineEdit
@onready var attack_defence_input = $MC/VBC/actor_manage/HBC/actor_attack_defence/LineEdit
@onready var magic_defence_input = $MC/VBC/actor_manage/HBC/actor_magic_defence/LineEdit
@onready var apply_button = $MC/VBC/actor_manage/HBC/actor_manage/actor_manage_btn
@onready var actor_element = $MC/VBC/actor_manage/HBC/actor_element

@onready var actor_list = $MC/VBC/actor_list/actor_list
@onready var actor_search = $MC/VBC/switch_pages/HBC/actor_search/actor_search

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
	refresh_database.connect(actor_list._refresh_database)

func _on_exit_button_pressed():
	exit_btn_pressed.emit()

func _on_previous_page_btn_pressed() -> void:
	actor_list._page_change(-1)

func _on_next_page_btn_pressed() -> void:
	actor_list._page_change(1)

func _on_actor_search_text_submitted(new_text: String) -> void:
	actor_list._search_ring(actor_search.text)


func _on_apply_pressed():
	var id = id_input.text.strip_edges()
	var actor_name = name_input.text.strip_edges()
	var level = level_input.text.strip_edges()
	var selected_element_index = actor_element.get_selected()  # 取得選擇的索引
	var element = actor_element.get_item_text(selected_element_index)
	var health = health_input.text.strip_edges()
	var attack_point = attack_point_input.text.strip_edges()
	var magic_point = magic_point_input.text.strip_edges()
	var attack_defence = attack_defence_input.text.strip_edges()
	var magic_defence = magic_defence_input.text.strip_edges()


	if [id, actor_name, level, element, health, attack_point, magic_point, attack_defence, magic_defence].has(""):
		await show_alert("❗請填寫所有欄位")
		return

	if not id.is_valid_int():
		await show_alert("⚠️ ID 必須為整數")
		return
	var id_val = int(id)
	if id_val <= 0:
		await show_alert("⚠️ ID 必須大於 0")
		return

	if not level.is_valid_int():
		await show_alert("⚠️ 等級必須為整數")
		return
	var lv = int(level)
	if lv < 0:
		await show_alert("⚠️ 等級需為非負整數")
		return

	if not health.is_valid_int():
		await show_alert("⚠️ 血量必須為整數")
		return
	var h = int(health)
	if h < 0:
		await show_alert("⚠️ 血量需為非負整數")
		return

	if not attack_point.is_valid_int():
		await show_alert("⚠️ 物理攻擊必須為整數")
		return
	var atk = int(attack_point)
	if atk < 0:
		await show_alert("⚠️ 物理攻擊需為非負整數")
		return

	if not magic_point.is_valid_int():
		await show_alert("⚠️ 魔法攻擊必須為整數")
		return
	var mp = int(magic_point)
	if mp < 0:
		await show_alert("⚠️ 魔法攻擊需為非負整數")
		return

	if not attack_defence.is_valid_int():
		await show_alert("⚠️ 物理防禦必須為整數")
		return
	var ad = int(attack_defence)
	if ad <= 0:
		await show_alert("⚠️ 物理防禦需為正整數")
		return

	if not magic_defence.is_valid_int():
		await show_alert("⚠️ 魔法防禦必須為整數")
		return
	var md = int(magic_defence)
	if md <= 0:
		await show_alert("⚠️ 魔法防禦需為正整數")
		return


	db.query("SELECT COUNT(*) as count FROM actor WHERE name = '" + actor_name + "' AND id != " + str(id_val))
	var result = db.query_result
	if result.size() > 0 and result[0].has("count") and int(result[0]["count"]) > 0:
		await show_alert("❌ 名稱已存在")
		return

	db.query("SELECT COUNT(*) as count FROM element WHERE name = '" + element + "'")
	result = db.query_result
	if result.size() == 0 or not result[0].has("count") or int(result[0]["count"]) == 0:
		await show_alert("❌ 所選 element 不存在")
		return

	db.query("SELECT COUNT(*) as count FROM actor WHERE id = " + str(id_val))
	result = db.query_result
	if result.size() > 0 and result[0].has("count") and int(result[0]["count"]) > 0:
	# ID 已存在，執行 UPDATE
		db.query("UPDATE actor SET name = '" + actor_name + "', level = " + str(lv) + ", element = '" + element + "', health = " + str(h) + ", attack_point = " + str(atk) + ", magic_point = " + str(mp) + ", attack_defence = " + str(ad) + ", magic_defence = " + str(md) + " WHERE id = " + str(id_val))
	else:
	# ID 不存在，執行 INSERT
		db.query("INSERT INTO actor (id, name, level, element, health, attack_point, magic_point, attack_defence, magic_defence) VALUES (" +
		str(id_val) + ", '" + actor_name + "', " + str(lv) + ", '" + element + "', " + str(h) + ", " + str(atk) + ", " + str(mp) + ", " + str(ad) + ", " + str(md) + ")")
	refresh_database.emit()
	show_alert("✅ 資料已儲存")
	actor_list.refresh()

func show_alert(msg: String):
	await get_tree().process_frame
	var dialog = AcceptDialog.new()
	dialog.dialog_text = msg
	add_child(dialog)
	dialog.popup_centered()

func _on_actor_manage_btn_pressed() -> void:
	_on_apply_pressed()
 


func _on_actor_list_show_alert(msg):
	show_alert(msg)
