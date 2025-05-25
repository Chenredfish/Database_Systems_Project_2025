extends BaseState
class_name s_Ready

var db := SQLite.new()

var available_skills:Array[Skill] = []
var available_rings:Array[Ring] = []
var available_equipment:Equipment = null

# 載入 Equipment 類別
const Equipment = preload("res://scr/object/equipment.gd")

func enter(_msg: Dictionary = {}):
	print("into state of s_Ready")
	
	agent.ui_layer.show_ui_ready()
	
	db.path = "res://data/game"
	db.open_db()

	var level = state_machine.get_value("level")
	var player = state_machine.get_value("player")
	
	free_actor("enemy")
	free_actor("player")
	
	create_level_enemy(level)


	available_skills = fetch_random_skills(level)
	available_rings = fetch_random_rings(level)
	available_equipment = fetch_random_equipment(level)
	print("隨機刷出裝備：" + str(available_equipment.get('name')) + ", 等級為：" + str(available_equipment.get('level')))
	
	state_machine.get_value('player').add_equipment_to_list(available_equipment.get('id'))
	
	
	agent.ui_layer.input_show_equipment_data(state_machine.get_value('player'))
	show_rings_selection()
	show_skills_selection()

func update(delta):
	pass

func exit():
	agent.ui_layer.hide_ui_ready()

func fetch_random_skills(level: int) -> Array[Skill]:
	var min_level = max(1, level - 2)
	db.query("SELECT * FROM skill WHERE level BETWEEN %d AND %d" % [min_level, level])
	var results = db.query_result.duplicate()
	results.shuffle()
	var skills:Array[Skill] = []
	for i in range(min(3, results.size())):
		skills.append(Skill.new(results[i]))
	return skills

func fetch_random_rings(level: int) -> Array[Ring]:
	var min_level = max(1, level - 2)
	db.query("SELECT * FROM ring WHERE level BETWEEN %d AND %d" % [min_level, level])
	var results = db.query_result.duplicate()
	results.shuffle()
	var rings:Array[Ring] = []
	for i in range(min(3, results.size())):
		rings.append(Ring.new(results[i]))
	return rings

func fetch_random_equipment(level: int) -> Equipment:
	var min_level = max(1, level - 2)
	db.query("SELECT * FROM equipment WHERE level BETWEEN %d AND %d" % [min_level, level])
	var results = db.query_result.duplicate()
	results.shuffle()
	return Equipment.new(results[0]) if results.size() > 0 else null

func free_actor(aim:String):
	for child in agent.get_children():
		if child.name == aim:
			child.queue_free()
		
func create_level_enemy(level:int):
	var enemy_data = db.select_rows("actor", "level = " + str(level), ["*"])
	if enemy_data.size() > 0:
		var rand_enemy_id:int = randi() % enemy_data.size()
		state_machine.set_value('enemy', Actor.new(enemy_data[rand_enemy_id]))
	else:
		print("enemy_data 是空的，無法選擇隨機敵人")

func show_rings_selection():
	var ring_nodes = [
		agent.ui_layer.ui_ready.get_node("MarginContainer/HBoxContainer/ring_and_skill/ring_list/HBoxContainer/ring1"),
		agent.ui_layer.ui_ready.get_node("MarginContainer/HBoxContainer/ring_and_skill/ring_list/HBoxContainer/ring2"),
		agent.ui_layer.ui_ready.get_node("MarginContainer/HBoxContainer/ring_and_skill/ring_list/HBoxContainer/ring3"),
	]

	for i in range(3):
		var ring = available_rings[i]
		var ring_node = ring_nodes[i]
		var name_label = ring_node.get_node("PanelContainer/VBoxContainer/ring_name")
		var effect_label = ring_node.get_node("PanelContainer/VBoxContainer/ring_effect")
		
		name_label.text = ring.get("name")
		
		var effect_text = ""
		effect_text += "等級：%d\n" % ring.get("level")
		
		var props = {
			"attack_power": ["物攻", ring.get("attack_power")],
			"magic_power": ["魔攻", ring.get("magic_power")],
			"attack_defence": ["物防", ring.get("attack_defence")],
			"magic_defence": ["魔防", ring.get("magic_defence")],
			"health": ["血量", ring.get("health")]
		}
		
		for key in props.keys():
			var label = props[key][0]
			var value = props[key][1]
			if typeof(value) in [TYPE_INT, TYPE_FLOAT] and float(value) != 0.0:
				var percent = int(round(float(value) * 100))
				var sign = "+" if percent > 0 else ""
				effect_text += "%s %s%d%%\n" % [label, sign, percent]

		effect_label.text = effect_text.strip_edges()
		
func show_skills_selection():
	var skill_nodes = [
		agent.ui_layer.ui_ready.get_node("MarginContainer/HBoxContainer/ring_and_skill/skill_list/HBoxContainer/skill1"),
		agent.ui_layer.ui_ready.get_node("MarginContainer/HBoxContainer/ring_and_skill/skill_list/HBoxContainer/skill2"),
		agent.ui_layer.ui_ready.get_node("MarginContainer/HBoxContainer/ring_and_skill/skill_list/HBoxContainer/skill3"),
	]

	for i in range(3):
		var skill = available_skills[i]
		var skill_node = skill_nodes[i]
		var name_label = skill_node.get_node("PanelContainer/VBoxContainer/skill_name")
		var desc_label = skill_node.get_node("PanelContainer/VBoxContainer/skill_desc")

		name_label.text = skill.get("name")

		var is_magic = int(skill.get("is_magic"))
		var damage_type_text = "物理傷害" if is_magic == 0 else "魔法傷害"
		var power_label = "物攻" if is_magic == 0 else "魔攻"
		var power_percent = int(float(skill.get("power")) * 100)
		var level = int(skill.get("level"))

		var desc_text = ""
		desc_text += "等級：%d\n" % level
		desc_text += "屬性：%s\n" % skill.get("element")
		desc_text += "%s\n" % damage_type_text
		desc_text += "倍率：%d%% %s\n" % [power_percent, power_label]
		desc_text += "冷卻時間：%ss" % str(skill.get("cooldown"))

		desc_label.text = desc_text.strip_edges()
