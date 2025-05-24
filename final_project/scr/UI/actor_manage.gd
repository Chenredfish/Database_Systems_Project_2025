extends MarginContainer
signal refresh_database

@onready var actor_id = $HBC/actor_id/LineEdit
@onready var actor_name = $HBC/actor_name/LineEdit
@onready var actor_level = $HBC/actor_level/LineEdit
@onready var actor_element = $HBC/actor_element/LineEdit
@onready var actor_health = $HBC/actor_health/LineEdit
@onready var actor_attack_point = $HBC/actor_attack_point/LineEdit
@onready var actor_magic_point = $HBC/actor_magic_point/LineEdit
@onready var actor_attack_defence = $HBC/actor_attack_defence/LineEdit
@onready var actor_magic_defence = $HBC/actor_magic_defence/LineEdit
@onready var db = SQLite.new()

func _ready():
	db.path = "res://data/game"
	db.open_db()

func _on_actor_manage_btn_pressed() -> void:
	var sql = "SELECT * FROM ring WHERE id = ?"
	db.query_with_bindings(sql,[str(actor_id.text)])
	var add_or_change = db.query_result
	print(add_or_change)
	if add_or_change.size() > 0:
		print("change")
		actor_change()
	else:
		print("add")
		actor_add()

func actor_change():
	var data = {
		"name":actor_name.text,
		"level":actor_level.text,
		"element":actor_element.text,
		"health":actor_health.text,
		"attack_point":actor_attack_point.text,
		"magic_point":actor_magic_point.text,
		"attack_defence":actor_attack_defence.text,
		"magic_defence":actor_magic_defence.text
	}
	db.update_rows("actor", "id = '" + actor_id.text + "'", data)
	refresh_database.emit()

func actor_add():
	var data = {
		"id":actor_id.text,
		"name":actor_name.text,
		"level":actor_level.text,
		"element":actor_element.text,
		"health":actor_health.text,
		"attack_point":actor_attack_point.text,
		"magic_point":actor_magic_point.text,
		"attack_defence":actor_attack_defence.text,
		"magic_defence":actor_magic_defence.text
	}
	db.insert_row("actor", data)
	refresh_database.emit()
