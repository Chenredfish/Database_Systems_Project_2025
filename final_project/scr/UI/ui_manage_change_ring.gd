extends Control

signal refresh_database
signal exit_btn_pressed
signal next_page_pressed

@onready var db = SQLite.new()

@onready var id_input = $MarginContainer/VBoxContainer/ring_manage/ring_status/HBoxContainer/ring_id/LineEdit
@onready var name_input = $MarginContainer/VBoxContainer/ring_manage/ring_status/HBoxContainer/ring_name/LineEdit
@onready var level_input = $MarginContainer/VBoxContainer/ring_manage/ring_status/HBoxContainer/ring_level/LineEdit
@onready var health_input = $MarginContainer/VBoxContainer/ring_manage/ring_status/HBoxContainer/ring_health/LineEdit
@onready var attack_power_input = $MarginContainer/VBoxContainer/ring_manage/ring_status/HBoxContainer/ring_attack_power/LineEdit
@onready var magic_power_input = $MarginContainer/VBoxContainer/ring_manage/ring_status/HBoxContainer/ring_magic_power/LineEdit
@onready var attack_defence_input = $MarginContainer/VBoxContainer/ring_manage/ring_status/HBoxContainer/ring_attack_defence/LineEdit
@onready var magic_defence_input = $MarginContainer/VBoxContainer/ring_manage/ring_status/HBoxContainer/ring_magic_defence/LineEdit
@onready var apply_button = $MarginContainer/VBoxContainer/ring_manage/ring_status/HBoxContainer/ring_manage/ring_manage_btn
@onready var list = $MarginContainer/VBoxContainer/ring_list/list
@onready var ring_search = $MarginContainer/VBoxContainer/switch_pages/HBoxContainer/ring_search/ring_search

func _ready():
	db.path = "res://data/game.db"
	db.open_db()
	if apply_button:
		apply_button.pressed.connect(_on_apply_pressed)

func _on_exit_button_pressed():
	exit_btn_pressed.emit()

func _on_next_page_btn_pressed() -> void:
	list._page_change(1)

func _on_previous_page_btn_pressed() -> void:
	list._page_change(-1)

func _on_ring_search_text_submitted(new_text: String) -> void:
	list._search_ring(ring_search.text)

func check_float_range(value_str: String, label: String) -> Variant:
	if value_str.strip_edges() == "":
		show_alert("❗請填寫所有欄位")
		return null
	if not value_str.is_valid_float():
		show_alert("⚠️ " + label + " 必須為小數")
		return null
	var v = float(value_str)
	if v < -1.0 or v > 1.0:
		show_alert("⚠️ " + label + " 必須介於 -1 到 1 之間")
		return null
	return v

func _on_apply_pressed():
	var id = id_input.text.strip_edges()
	var name = name_input.text.strip_edges()
	var level = level_input.text.strip_edges()
	var health = health_input.text.strip_edges()
	var attack_power = attack_power_input.text.strip_edges()
	var magic_power = magic_power_input.text.strip_edges()
	var attack_defence = attack_defence_input.text.strip_edges()
	var magic_defence = magic_defence_input.text.strip_edges()

	if id == "" or name == "" or level == "" or health == "" or attack_power == "" or magic_power == "" or attack_defence == "" or magic_defence == "":
		show_alert("❗請填寫所有欄位")
		return

	if not id.is_valid_int():
		show_alert("⚠️ ID 必須為整數")
		return
	var id_val = int(id)
	if id_val <= 0:
		show_alert("⚠️ ID 必須大於 0")
		return

	if not level.is_valid_int():
		show_alert("⚠️ 等級必須為整數")
		return
	var lv = int(level)
	if lv <= 0:
		show_alert("⚠️ 等級需為正整數")
		return

	var h = check_float_range(health, "血量加成")
	var ap = check_float_range(attack_power, "物理攻擊加成")
	var mp = check_float_range(magic_power, "魔法攻擊加成")
	var ad = check_float_range(attack_defence, "物理防禦加成")
	var md = check_float_range(magic_defence, "魔法防禦加成")

	if h == null or ap == null or mp == null or ad == null or md == null:
		return

	db.query("SELECT COUNT(*) as count FROM ring WHERE id = " + str(id_val))
	var result = db.query_result
	if result.size() > 0 and result[0].has("count") and result[0]["count"] > 0:
		show_alert("❌ ID 已存在")
		return

	db.query("SELECT COUNT(*) as count FROM ring WHERE name = '" + name + "'")
	result = db.query_result
	if result.size() > 0 and result[0].has("count") and result[0]["count"] > 0:
		show_alert("❌ 名稱已存在")
		return

	db.query("INSERT INTO ring (id, name, level, health, attack_power, magic_power, attack_defence, magic_defence) VALUES (" +
		str(id_val) + ", '" + name + "', " + str(lv) + ", " + str(h) + ", " + str(ap) + ", " + str(mp) + ", " + str(ad) + ", " + str(md) + ")")

	emit_signal("next_page_pressed")
	refresh_database.emit()
	show_alert("✅ 資料已儲存")

func show_alert(msg: String):
	await get_tree().process_frame  # 確保 UI 準備好再顯示
	var dialog = AcceptDialog.new()
	dialog.dialog_text = msg
	dialog.get_ok_button().show()
	add_child(dialog)
	dialog.popup_centered()

func _on_ring_manage_btn_pressed() -> void:
	_on_apply_pressed()
