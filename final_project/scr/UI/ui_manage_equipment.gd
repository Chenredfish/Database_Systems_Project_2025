extends Control

signal refresh_database
signal exit_btn_pressed

@onready var db = SQLite.new()

@onready var id_input = %LineEdit_1
@onready var name_input = %LineEdit_2
@onready var level_input = %LineEdit_3
@onready var attack_defence_input = %LineEdit_4
@onready var magic_defence_input = %LineEdit_5
@onready var apply_button = %equipment_manage_btn

@onready var equipment_list = $MC/VBC/equipment_list/equipment_list
@onready var equipment_search = $MC/VBC/switch_pages/HBC/equipment_search/LineEdit

func _ready():
	db.path = "res://data/game.db"
	db.open_db()
	refresh_database.connect(equipment_list._refresh_db)
	if apply_button:
		apply_button.pressed.connect(_on_apply_pressed)

func _on_exit_button_pressed():
	exit_btn_pressed.emit()

func _on_previous_page_btn_pressed() -> void:
	equipment_list._page_change(-1)

func _on_next_page_btn_pressed() -> void:
	equipment_list._page_change(1)

func _on_equipment_search_text_submitted(new_text: String) -> void:
	equipment_list._search_ring(equipment_search.text)

func _on_apply_pressed():
	var id = id_input.text.strip_edges()
	var name = name_input.text.strip_edges()
	var level = level_input.text.strip_edges()
	var attack_defence = attack_defence_input.text.strip_edges()
	var magic_defence = magic_defence_input.text.strip_edges()

	if [id, name, level, attack_defence, magic_defence].has(""):
		show_alert("❗請填寫所有欄位")
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

	db.query_with_args("SELECT COUNT(*) as count FROM equipment WHERE id = ?", [id])
	if db.query_result[0]["count"] > 0:
		show_alert("❌ ID 已存在")
		return

	db.query_with_args("SELECT COUNT(*) as count FROM equipment WHERE name = ?", [name])
	if db.query_result[0]["count"] > 0:
		show_alert("❌ 名稱已存在")
		return

	db.query_with_args(
		"INSERT INTO equipment (id, name, level, attack_defence, magic_defence) VALUES (?, ?, ?, ?, ?)",
		[id, name, lv, ad, md]
	)
	refresh_database.emit()
	show_alert("資料已儲存")

func show_alert(msg: String):
	var dialog = AcceptDialog.new()
	dialog.dialog_text = msg
	add_child(dialog)
	dialog.popup_centered()
