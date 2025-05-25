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
	db.path = "res://data/game.db"
	db.open_db()

func _on_exit_button_pressed():
	exit_btn_pressed.emit()

func _on_next_page_btn_pressed() -> void:
	skill_list._page_change(1)

func _on_previous_page_btn_pressed() -> void:
	skill_list._page_change(-1)

func _on_skill_search_text_submitted(new_text: String) -> void:
	skill_list._search_skill(skill_search.text)

func _on_apply_pressed():
	var id = id_input.text.strip_edges()
	var name = name_input.text.strip_edges()
	var level = level_input.text.strip_edges()
	var element = element_input.text.strip_edges()
	var is_magic = is_magic_input.text.strip_edges()
	var power = power_input.text.strip_edges()
	var cooldown = cooldown_input.text.strip_edges()

	for field in [id, name, level, element, is_magic, power, cooldown]:
		if field.strip_edges() == "":
			show_alert("❗請勿留空或只輸入空格")
			return

	if not level.is_valid_int() or not is_magic.is_valid_int() or not cooldown.is_valid_int():
		show_alert("⚠️ level, is_magic, cooldown 必須是整數")
		return

	if not power.is_valid_float():
		show_alert("⚠️ 攻擊係數必須為小數")
		return

	var lv = int(level)
	var magic = int(is_magic)
	var cd = int(cooldown)
	var pw = float(power)

	if lv < 0:
		show_alert("⚠️ level 需為非負整數")
		return
	if magic != 0 and magic != 1:
		show_alert("⚠️ is_magic 僅能為 0 或 1")
		return
	if cd < 1 or cd > 3:
		show_alert("⚠️ cooldown 必須為 1～3 間整數")
		return
	if pw < 1.0 or pw > 2.0:
		show_alert("⚠️ power 必須介於 1.0～2.0 之間")
		return

		db.query("SELECT COUNT(*) as count FROM skill WHERE id = '" + id + "'")
	if db.query_result.size() > 0 and db.query_result[0].has("count") and db.query_result[0]["count"] > 0:
		show_alert("❌ ID 已存在")
		return

	db.query("SELECT COUNT(*) as count FROM skill WHERE name = '" + name + "'")
	if db.query_result.size() > 0 and db.query_result[0].has("count") and db.query_result[0]["count"] > 0:
		show_alert("❌ 名稱已存在")
		return

	db.query("SELECT COUNT(*) as count FROM element WHERE id = '" + element + "'")
	if db.query_result.size() > 0 and db.query_result[0].has("count") and db.query_result[0]["count"] == 0:
		show_alert("❌ element 不存在")
		return

	db.query("INSERT INTO skill (id, name, level, element, is_magic, power, cooldown) VALUES ('" + id + "', '" + name + "', " + str(lv) + ", '" + element + "', " + str(magic) + ", " + str(pw) + ", " + str(cd) + ")")
	
	refresh_database.emit()
	show_alert("資料已儲存")

func show_alert(msg: String):
	var dialog = AcceptDialog.new()
	dialog.dialog_text = msg
	add_child(dialog)
	dialog.popup_centered()

func _on_skill_manage_btn_pressed() -> void:
	_on_apply_pressed()
