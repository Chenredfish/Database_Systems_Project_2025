extends MarginContainer

@onready var ring_id = $ring_status/HBoxContainer/ring_id/LineEdit
@onready var ring_name = $ring_status/HBoxContainer/ring_name/LineEdit
@onready var ring_level = $ring_status/HBoxContainer/ring_level/LineEdit
@onready var ring_health = $ring_status/HBoxContainer/ring_health/LineEdit
@onready var ring_attack_power = $ring_status/HBoxContainer/ring_attack_power/LineEdit
@onready var ring_magic_power =$ring_status/HBoxContainer/ring_magic_power/LineEdit
@onready var ring_attack_defence =$ring_status/HBoxContainer/ring_attack_defence/LineEdit
@onready var ring_magic_defence =$ring_status/HBoxContainer/ring_magic_defence/LineEdit
@onready var db = SQLite.new()

func _ready():
	db.path = "res://data/game"
	db.open_db()
	
func _on_ring_manage_btn_pressed():
	var sql = "SELECT * FROM ring WHERE id = ?"
	db.query_with_bindings(sql,[str(ring_id.text)])
	var add_or_change = db.query_result
	print(add_or_change)
	if add_or_change.size() > 0:
		print("change")
		ring_change()
	else:
		print("add")
		ring_add()

func ring_delete():
	db.delete_rows("ring", "id = '" + ring_id.text + "'")

func ring_change():
	var data = {
		"name":ring_name.text,
		"level":ring_level.text,
		"health":ring_health.text,
		"attack_power":ring_attack_power.text,
		"magic_power":ring_magic_power.text,
		"attack_defence":ring_attack_defence.text,
		"magic_defence":ring_magic_defence.text
	}
	db.update_rows("ring", "id = '" + ring_id.text + "'", data)

func ring_add():
	var data = {
		"id":ring_id.text,
		"name":ring_name.text,
		"level":ring_level.text,
		"health":ring_health.text,
		"attack_power":ring_attack_power.text,
		"magic_power":ring_magic_power.text,
		"attack_defence":ring_attack_defence.text,
		"magic_defence":ring_magic_defence.text
	}
	db.insert_row("ring", data)
