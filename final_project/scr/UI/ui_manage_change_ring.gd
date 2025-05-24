extends Control

signal refresh_database
signal exit_btn_pressed

@onready var db = SQLite.new()

@onready var id_input = %LineEdit_1
@onready var name_input = %LineEdit_2
@onready var level_input = %LineEdit_3
@onready var health_input = %LineEdit_4
@onready var attack_power_input = %LineEdit_5
@onready var magic_power_input = %LineEdit_6
@onready var attack_defence_input = %LineEdit_7
@onready var magic_defence_input = %LineEdit_8
@onready var apply_button = %ring_manage_btn

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

func _on_apply_pressed():
	var id = id_input.text.strip_edges()
	var name = name_input.text.strip_edges()
	var level = level_input.text.strip_edges()
	var health = health_input.text.strip_edges()
	var attack_power = attack_power_input.text.strip_edges()
	var magic_power = magic_power_input.text.strip_edges()
	var attack_defence = attack_defence_input.text.strip_edges()
	var magic_defence = magic_defence_input.text.strip_edges()

	if [id, name, level, health, attack_power, magic_power, attack_defence, magic_defence].has(""):
		show_alert("❗請填寫所有欄位")
		return

	var float_fields = [health, attack_power, magic_power, attack_defence, magic_defence]
	for val in float_fields:
		if not val.is_valid_float():
			show_alert("⚠️ 數值欄位需為小數")
			return

	if not level.is_valid_int():
		show_alert("⚠️ level 必須是整數")
		return

	var lv = int(level)
	if lv <= 0:
		show_alert("⚠️ level 必須大於 0")
		return

	var health_f = float(health)
	if health_f < -1.0 or health_f > 1.0:
		show_alert("⚠️ health 必須介於 -1 到 1 之間")
		return

	var attack_power_f = float(attack_power)
	if attack_power_f < -1.0 or attack_power_f > 1.0:
		show_alert("⚠️ attack_power 必須介於 -1 到 1 之間")
		return

	var magic_power_f = float(magic_power)
	if magic_power_f < -1.0 or magic_power_f > 1.0:
		show_alert("⚠️ magic_power 必須介於 -1 到 1 之間")
		return

	var attack_defence_f = float(attack_defence)
	if attack_defence_f < -1.0 or attack_defence_f > 1.0:
		show_alert("⚠️ attack_defence 必須介於 -1 到 1 之間")
		return

	var magic_defence_f = float(magic_defence)
	if magic_defence_f < -1.0 or magic_defence_f > 1.0:
		show_alert("⚠️ magic_defence 必須介於 -1 到 1 之間")
		return

	db.query_with_args("SELECT COUNT(*) as count FROM ring WHERE id = ?", [id])
	if db.query_result[0]["count"] > 0:
		show_alert("❌ ID 已存在")
		return

	db.query_with_args("SELECT COUNT(*) as count FROM ring WHERE name = ?", [name])
	if db.query_result[0]["count"] > 0:
		show_alert("❌ 名稱已存在")
		return

	db.query_with_args(
		"INSERT INTO ring (id, name, level, health, attack_power, magic_power, attack_defence, magic_defence) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
		[id, name, lv, health_f, attack_power_f, magic_power_f, attack_defence_f, magic_defence_f]
	)
	refresh_database.emit()
	show_alert("資料已儲存")

func show_alert(msg: String):
	var dialog = AcceptDialog.new()
	dialog.dialog_text = msg
	add_child(dialog)
	dialog.popup_centered()
