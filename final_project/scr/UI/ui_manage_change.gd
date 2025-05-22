extends Control

# 正確抓取所有 LineEdit 元件
@onready var id_input = %equipment_id/LineEdit
@onready var name_input = %equipment_name/LineEdit
@onready var level_input = %equipment_level/LineEdit
@onready var pdef_input = %equipment_attack_defence/LineEdit
@onready var mdef_input = %equipment_magic_defence/LineEdit
@onready var apply_button = %equipment_manage/equipment_manage_btn

# 資料庫連線
var db := SQLite.new()

func _ready():
	db.path = "res://data/game.db"  # 資料庫位置
	db.open_db()
	#apply_button.pressed.connect(_on_apply_pressed)  # 綁定按鈕點擊事件

func _on_apply_pressed():
	var id = id_input.text.strip_edges()
	var name = name_input.text.strip_edges()
	var level = level_input.text
	var pdef = pdef_input.text
	var mdef = mdef_input.text

	#空白檢查
	if id == "" or name == "" or level == "" or pdef == "" or mdef == "":
		show_alert("❗請填寫所有欄位")
		return

	#格式檢查（是否為整數）
	if not level.is_valid_int() or not pdef.is_valid_int() or not mdef.is_valid_int():
		show_alert("⚠️ 裝備等級與防禦值必須是整數")
		return

	var level_int = int(level)
	var pdef_int = int(pdef)
	var mdef_int = int(mdef)

	#不能為負數
	if level_int < 0 or pdef_int < 0 or mdef_int < 0:
		show_alert("⚠️ 數值不可為負")
		return

	#防禦不能同時為 0
	if pdef_int == 0 and mdef_int == 0:
		show_alert("⚠️ 物理與魔法防禦不可同時為 0")
		return

	#裝備 ID 不可重複
	db.query_with_args("SELECT COUNT(*) as count FROM equipment WHERE id = ?", [id])
	if db.query_result[0]["count"] > 0:
		show_alert("❌ 裝備代號已存在")
		return

	#裝備名稱不可重複
	db.query_with_args("SELECT COUNT(*) as count FROM equipment WHERE name = ?", [name])
	if db.query_result[0]["count"] > 0:
		show_alert("❌ 裝備名稱已存在")
		return

	#通過驗證 → 寫入資料庫
	db.query_with_args(
		"INSERT INTO equipment (id, name, attack_defence, magic_defence, level) VALUES (?, ?, ?, ?, ?)",
		[id, name, pdef_int, mdef_int, level_int]
	)

	show_alert("✅ 新增成功，資料已儲存")

	#清空欄位
	id_input.text = ""
	name_input.text = ""
	level_input.text = ""
	pdef_input.text = ""
	mdef_input.text = ""

# 顯示訊息彈窗
func show_alert(msg: String):
	var dialog = AcceptDialog.new()
	dialog.dialog_text = msg
	add_child(dialog)
	dialog.popup_centered()


func _on_equipment_manage_btn_pressed() -> void:
	_on_apply_pressed()
