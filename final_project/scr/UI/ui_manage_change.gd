extends Control

signal refresh_database
signal exit_btn_pressed

@onready var db = SQLite.new()

@onready var id_input = $MC/VBC/actor_manage/HBC/actor_id/LineEdit
@onready var name_input = $MC/VBC/actor_manage/HBC/actor_name/LineEdit
@onready var level_input = $MC/VBC/actor_manage/HBC/actor_level/LineEdit
@onready var element_input = $MC/VBC/actor_manage/HBC/actor_element/LineEdit
@onready var health_input = $MC/VBC/actor_manage/HBC/actor_health/LineEdit
@onready var attack_point_input = $MC/VBC/actor_manage/HBC/actor_attack_point/LineEdit
@onready var magic_point_input = $MC/VBC/actor_manage/HBC/actor_magic_point/LineEdit
@onready var attack_defence_input = $MC/VBC/actor_manage/HBC/actor_attack_defence/LineEdit
@onready var magic_defence_input = $MC/VBC/actor_manage/HBC/actor_magic_defence/LineEdit
@onready var apply_button = $MC/VBC/actor_manage/HBC/actor_manage/actor_manage_btn

@onready var actor_list = $MC/VBC/actor_list/actor_list
@onready var actor_search = $MC/VBC/switch_pages/HBC/actor_search/actor_search

func _ready():
	db.path = "res://data/game.db"
	db.open_db()
	#refresh_database.connect(actor_list._refresh_database)

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
	if lv < 0:
		show_alert("⚠️ 等級需為非負整數")
		return

	if not health.is_valid_int():
		show_alert("⚠️ 血量必須為整數")
		return
	var h = int(health)
	if h < 0 or h % 100 != 0:
		show_alert("⚠️ 血量需為非負且為100的倍數")
		return

	if not attack_point.is_valid_int():
		show_alert("⚠️ 物理攻擊必須為整數")
		return
	var atk = int(attack_point)
	if atk < 0 or atk % 10 != 0:
		show_alert("⚠️ 物理攻擊需為非負且為10的倍數")
		return

	if not magic_point.is_valid_int():
		show_alert("⚠️ 魔法攻擊必須為整數")
		return
	var mp = int(magic_point)
	if mp < 0 or mp % 10 != 0:
		show_alert("⚠️ 魔法攻擊需為非負且為10的倍數")
		return

	if not attack_defence.is_valid_int():
		show_alert("⚠️ 物理防禦必須為整數")
		return
	var ad = int(attack_defence)
	if ad <= 0:
		show_alert("⚠️ 物理防禦需為正整數")
		return

	if not magic_defence.is_valid_int():
		show_alert("⚠️ 魔法防禦必須為整數")
		return
	var md = int(magic_defence)
	if md <= 0:
		show_alert("⚠️ 魔法防禦需為正整數")
		return

	db.query("SELECT COUNT(*) as count FROM actor WHERE id = " + str(id_val))
	if db.query_result[0]["count"] > 0:
		show_alert("❌ ID 已存在")
		return

	db.query("SELECT COUNT(*) as count FROM actor WHERE name = '" + name + "'")
	if db.query_result[0]["count"] > 0:
		show_alert("❌ 名稱已存在")
		return

	db.query("SELECT COUNT(*) as count FROM element WHERE id = '" + element + "'")
	if db.query_result[0]["count"] == 0:
		show_alert("❌ 所選 element 不存在")
		return

	db.query("INSERT INTO actor (id, name, level, element, health, attack_point, magic_point, attack_defence, magic_defence) VALUES (" +
		str(id_val) + ", '" + name + "', " + str(lv) + ", '" + element + "', " + str(h) + ", " + str(atk) + ", " + str(mp) + ", " + str(ad) + ", " + str(md) + ")")

	refresh_database.emit()
	show_alert("✅ 資料已儲存")

func show_alert(msg: String):
	var dialog = AcceptDialog.new()
	dialog.dialog_text = msg
	add_child(dialog)
	dialog.popup_centered()

func _on_actor_manage_btn_pressed() -> void:
	_on_apply_pressed()
