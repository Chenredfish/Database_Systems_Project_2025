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
	db.path = "res://data/game.db"
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
	var dialog = AcceptDialog.new()
	dialog.dialog_text = msg
	add_child(dialog)
	dialog.popup_centered()


func _on_apply_pressed():
	# 取得欄位值並去除前後空格
	var id = id_input.text.strip_edges()
	var name = name_input.text.strip_edges()
	var level = level_input.text.strip_edges()
	var attack_defence = attack_defence_input.text.strip_edges()
	var magic_defence = magic_defence_input.text.strip_edges()

	for field in [id, name, level, attack_defence, magic_defence]:
		if field.strip_edges() == "" or field.strip_edges().is_empty():
			show_alert("❗請勿留空或只輸入空格")
			return

	if not level.is_valid_int() or not attack_defence.is_valid_int() or not magic_defence.is_valid_int():
		show_alert("⚠️ level、attack_defence、magic_defence 必須為整數")
		return

	var lv = int(level)
	var ad = int(attack_defence)
	var md = int(magic_defence)

	if lv < 0:
		show_alert("⚠️ level 必須為非負整數")
		return
	if ad <= 0 or md <= 0:
		show_alert("⚠️ 防禦力需為正整數")
		return

	db.query("SELECT COUNT(*) as count FROM equipment WHERE id = '" + id + "'")
	if db.query_result.size() > 0 and db.query_result[0].has("count") and db.query_result[0]["count"] > 0:
		show_alert("❌ ID 已存在")
		return

	db.query("SELECT COUNT(*) as count FROM equipment WHERE name = '" + name + "'")
	if db.query_result.size() > 0 and db.query_result[0].has("count") and db.query_result[0]["count"] > 0:
		show_alert("❌ 名稱已存在")
		return

	db.query("INSERT INTO equipment (id, name, level, attack_defence, magic_defence) VALUES ('" + id + "', '" + name + "', " + str(lv) + ", " + str(ad) + ", " + str(md) + ")")

	refresh_database.emit()
	show_alert("✅ 資料已儲存")

func _on_equipment_manage_btn_pressed() -> void:
	_on_apply_pressed()
 
