extends BaseState
class_name s_Ready

var db := SQLite.new()

var available_skills = []
var available_rings = []
var available_equipment = null

func enter(_msg: Dictionary = {}):
	print("into state of s_Ready")
	
	agent.ui_layer.show_ui_ready()
	
	db.path = "res://data/game"
	db.open_db()

	var level = state_machine.get_value("level")
	var player = state_machine.get_value("player")
	
	update_level()
	
	free_actor("enemy")
	free_actor("player")
	
	create_level_enemy(level)


	available_skills = fetch_random_skills(level)
	available_rings = fetch_random_rings(level)
	available_equipment = fetch_random_equipment(level)

	#存變數到狀態機
	state_machine.set_value("available_skills", available_skills)
	state_machine.set_value("available_rings", available_rings)
	state_machine.set_value("available_equipment", available_equipment)
	
	show_rings_selection() #顯示ring，挑ring
	show_skills_selection()

func update(delta):
	pass

func exit():
	agent.ui_layer.hide_ui_ready()

#從enter裡拉出選skill、ring、equip
func fetch_random_skills(level: int) -> Array:
	var min_level = max(1, level - 2)
	db.query("SELECT * FROM skill WHERE level BETWEEN %d AND %d" % [min_level, level])
	var results = db.query_result.duplicate()
	results.shuffle()
	return results.slice(0, 3)

func fetch_random_rings(level: int) -> Array:
	var min_level = max(1, level - 2)
	db.query("SELECT * FROM ring WHERE level BETWEEN %d AND %d" % [min_level, level])
	var results = db.query_result.duplicate()
	results.shuffle()
	return results.slice(0, 3)

func fetch_random_equipment(level: int) -> Dictionary:
	var min_level = max(1, level - 2)
	db.query("SELECT * FROM equipment WHERE level BETWEEN %d AND %d" % [min_level, level])
	var results = db.query_result.duplicate()
	results.shuffle()
	return results[0] if results.size() > 0 else null

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

#更新目前的level, 打五次同個level就來
func update_level():
	pass

#挑選ring環節	，顯示到ui_ready
func show_rings_selection():
	var ring_nodes = [
		agent.ui_layer.ui_ready.get_node("MarginContainer/HBoxContainer/ring_and_skill/ring_list/HBoxContainer/ring1"),
		agent.ui_layer.ui_ready.get_node("MarginContainer/HBoxContainer/ring_and_skill/ring_list/HBoxContainer/ring2"),
		agent.ui_layer.ui_ready.get_node("MarginContainer/HBoxContainer/ring_and_skill/ring_list/HBoxContainer/ring3"),
	]

	for i in range(3):
		var ring_data = available_rings[i]
		var ring_node = ring_nodes[i]
		var name_label = ring_node.get_node("PanelContainer/VBoxContainer/ring_name")
		var effect_label = ring_node.get_node("PanelContainer/VBoxContainer/ring_effect")

		name_label.text = ring_data["name"]
		
		var effect_text = ""
		var props = {
			"attack_power": "物攻",
			"magic_power": "魔攻",
			"attack_defence": "物防",
			"magic_defence": "魔防",
			"health": "血量"
		}
		
		for key in props.keys():
			if int(ring_data[key]) != 0:
				effect_text += "%s +%d\n" % [props[key], int(ring_data.get(key, 0))]
		
		effect_label.text = effect_text.strip_edges()
		
func show_skills_selection():
	var skill_nodes = [
		agent.ui_layer.ui_ready.get_node("MarginContainer/HBoxContainer/ring_and_skill/skill_list/HBoxContainer/skill1"),
		agent.ui_layer.ui_ready.get_node("MarginContainer/HBoxContainer/ring_and_skill/skill_list/HBoxContainer/skill2"),
		agent.ui_layer.ui_ready.get_node("MarginContainer/HBoxContainer/ring_and_skill/skill_list/HBoxContainer/skill3"),
	]

	for i in range(3):
		var skill_data = available_skills[i]
		var skill_node = skill_nodes[i]
		var name_label = skill_node.get_node("PanelContainer/VBoxContainer/skill_name")
		var desc_label = skill_node.get_node("PanelContainer/VBoxContainer/skill_desc")

		name_label.text = skill_data["name"]

		var is_magic = int(skill_data["is_magic"])
		var damage_type_text = "物理傷害" if is_magic == 0 else "魔法傷害"
		var power_label = "物攻" if is_magic == 0 else "魔攻"

		var power_percent = int(float(skill_data["power"]) * 100)

		var desc_text = ""
		desc_text += "屬性：%s\n" % skill_data["element"]
		desc_text += "%s\n" % damage_type_text
		desc_text += "倍率：%d%% %s\n" % [power_percent, power_label]
		desc_text += "冷卻時間：%ss" % str(skill_data["cooldown"])

		desc_label.text = desc_text.strip_edges()
