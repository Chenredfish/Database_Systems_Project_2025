extends MarginContainer

@onready var skill_choices: VBoxContainer = $skills/skill_choices
@onready var skill_test: HBoxContainer = $skills/skill_choices/skill_test
@onready var skill_chosen = $skills/skill_chosen/VBC
@onready var db = SQLite.new()
var all_skill_data
var check_deleted = {"id": "已刪除",
 "name": "已刪除",
 "level": "已刪除", 
"is_magic": "已刪除", 
"power": "已刪除",
"cooldown": "已刪除",
"element": "已刪除"}

func _ready():
	db.path = "res://data/game.db"
	db.open_db()
	all_skill_data = db.select_rows("skill", "id > 0", ["*"])
	skill_test.hide()

func _skill_page_update(round_data):
	for child in skill_choices.get_children():
		if child.name != "skill_test" and child.name != "skill_id_name":
			child.queue_free()
	
	var sql = "SELECT * FROM skill WHERE id = ?"
	var target_skill
	for new_skill in range(1,4):
		var new_skill_choice = skill_test.duplicate()
		new_skill_choice.name = "new_skill_choice" + str(new_skill)
		skill_choices.add_child(new_skill_choice)
		new_skill_choice.show()
		new_skill_choice.get_node("skill_id/Label").text = str(round_data["skill_choice_id_" + str(new_skill)])
		db.query_with_bindings(sql, [round_data["skill_choice_id_" + str(new_skill)]])
		target_skill = _check_delete(db.query_result)
		new_skill_choice.get_node("skill_name/Label").text = target_skill["name"]
	
	db.query_with_bindings(sql, [round_data["player_skill_id"]])
	target_skill = _check_delete(db.query_result)
	skill_chosen.get_node("skill_name").text = str(target_skill["name"])
	skill_chosen.get_node("skill_level").text = "技能代號：" + str(target_skill["id"])
	skill_chosen.get_node("skill_level").text = "技能等級：" + str(target_skill["level"])
	skill_chosen.get_node("skill_element").text = "屬性：" + str(target_skill["element"])
	skill_chosen.get_node("skill_is_magic").text = "攻擊類別：" + str(target_skill["is_magic"])
	skill_chosen.get_node("skill_power").text = "攻擊係數：" + str(target_skill["power"])
	skill_chosen.get_node("skill_cooldown").text = "技能冷卻：" + str(target_skill["cooldown"])

func _check_delete(target : Array):
	print(target)
	if target == []:
		return check_deleted
	else:
		return target[0]
