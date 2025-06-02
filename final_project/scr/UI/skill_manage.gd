extends MarginContainer

signal refresh_database

@onready var skill_id = $skill_status/HBoxContainer/skill_id/LineEdit
@onready var skill_name = $skill_status/HBoxContainer/skill_name/LineEdit
@onready var skill_level = $skill_status/HBoxContainer/skill_level/LineEdit
@onready var skill_element = $skill_status/HBoxContainer/skill_element/LineEdit
@onready var skill_is_magic = $skill_status/HBoxContainer/skill_is_magic/LineEdit
@onready var skill_power = $skill_status/HBoxContainer/skill_power/LineEdit
@onready var skill_cooldown = $skill_status/HBoxContainer/skill_cooldown/LineEdit
@onready var db = SQLite.new()

func _ready():
	db.path = "res://data/game"
	db.open_db()
	
func _on_skill_manage_btn_pressed() -> void:
	
	pass

	#var sql = "SELECT * FROM skill WHERE id = ?"
	#db.query_with_bindings(sql,[str(skill_id.text)])
	#var add_or_change = db.query_result
	#print(add_or_change)
	#if add_or_change.size() > 0:
		#print("change")
		#skill_change()
	#else:
		#print("add")
		#skill_add()
		#

func skill_change():
	var data = {
		"name":skill_name.text,
		"level":skill_level.text,
		"element":skill_element.text,
		"is_magic":skill_is_magic.text,
		"power":skill_power.text,
		"cooldown":skill_cooldown.text,
	}
	db.update_rows("skill", "id = '" + skill_id.text + "'", data)
	refresh_database.emit()

func skill_add():
	var data = {
		"id":skill_id.text,
		"name":skill_name.text,
		"level":skill_level.text,
		"element":skill_element.text,
		"is_magic":skill_is_magic.text,
		"power":skill_power.text,
		"cooldown":skill_cooldown.text,
	}
	db.insert_row("skill", data)
	refresh_database.emit()
