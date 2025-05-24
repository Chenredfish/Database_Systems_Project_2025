extends Control

signal refresh_database
signal exit_btn_pressed

var db := SQLite.new()

@onready var id_input = %LineEdit_1
@onready var name_input = %LineEdit_2
@onready var level_input = %LineEdit_3
@onready var element_input = %LineEdit_4
@onready var health_input = %LineEdit_5
@onready var attack_point_input = %LineEdit_6
@onready var magic_point_input = %LineEdit_7
@onready var attack_defence_input = %LineEdit_8
@onready var magic_defence_input = %LineEdit_9
@onready var apply_button = %actor_manage_btn

@onready var actor_list = $MC/VBC/actor_list/actor_list
@onready var actor_search = $MC/VBC/switch_pages/HBC/actor_search/actor_search

func _ready():
	db.path = "res://data/game.db"
	db.open_db()
	refresh_database.connect(actor_list._refresh_database)
	if apply_button:
		apply_button.pressed.connect(_on_apply_pressed)

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
	var name = name_input.text.strip_edges()
	var level = level_input.text.strip_edges()
	var element = element_input.text.strip_edges()
	var health = health_input.text.strip_edges()
	var attack_point = attack_point_input.text.strip_edges()
	var magic_point = magic_point_input.text.strip_edges()
	var attack_defence = attack_defence_input.text.strip_edges()
	var magic_defence = magic_defence_input.text.strip_edges()

	if [id, name, level, element, health, attack_point, magic_point, attack_defence, magic_defence].has(""):
		show_alert("❗請填寫所有欄位")
		return

	if not level.is_valid_int() or not health.is_valid_int() or not attack_point.is_valid_int() or not magic_point.is_valid_int() or not attack_defence.is_valid_int() or not magic_defence.is_valid_int():
		show_alert("⚠️ 數值欄位需為整數")
		return

	var lv = int(level)
	var h = int(health)
	var atk = int(attack_point)
	var mp = int(magic_point)
	var ad = int(attack_defence)
	var md = int(magic_defence)

	if lv < 0:
		show_alert("⚠️ 等級需為非負整數")
		return
	if h < 0 or h % 100 != 0:
		show_alert("⚠️ 血量需為非負且為100的倍數")
		return
	if atk < 0 or atk % 10 != 0:
		show_alert("⚠️ 攻擊力需為非負且為10的倍數")
		return
	if mp < 0 or mp % 10 != 0:
		show_alert("⚠️ 魔力需為非負且為10的倍數")
		return
	if ad <= 0 or md <= 0:
		show_alert("⚠️ 防禦需為正整數")
		return

	db.query_with_args("SELECT COUNT(*) as count FROM actor WHERE id = ?", [id])
	if db.query_result[0]["count"] > 0:
		show_alert("❌ ID 已存在")
		return

	db.query_with_args("SELECT COUNT(*) as count FROM actor WHERE name = ?", [name])
	if db.query_result[0]["count"] > 0:
		show_alert("❌ 名稱已存在")
		return

	db.query_with_args("SELECT COUNT(*) as count FROM element WHERE id = ?", [element])
	if db.query_result[0]["count"] == 0:
		show_alert("❌ 所選 element 不存在")
		return

	# 寫入資料庫
	db.query_with_args(
		"INSERT INTO actor (id, name, level, element, health, attack_point, magic_point, attack_defence, magic_defence) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
		[id, name, lv, element, h, atk, mp, ad, md]
	)

	refresh_database.emit()
	show_alert("✅ 資料已儲存")

func show_alert(msg: String):
	var dialog = AcceptDialog.new()
	dialog.dialog_text = msg
	add_child(dialog)
	dialog.popup_centered()
