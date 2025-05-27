extends BaseState
class_name s_Ready

var db := SQLite.new()

var available_skills:Array[Skill] = []
var available_rings:Array[Ring] = []
var available_equipments:Array[Equipment] = []
var new_skill:Skill
var new_ring:Ring
var new_equipment:Equipment

var is_next_wave:bool = false

# 載入 Equipment 類別
const Equipment = preload("res://scr/object/equipment.gd")

func enter(_msg: Dictionary = {}):
	print("into state of s_Ready")
	
	agent.ui_layer.show_ui_ready()
	
	db.path = "res://data/game"
	db.open_db()

	var level = state_machine.get_value("level")
	var player = state_machine.get_value("player")
	
	if !state_machine.has_value('is_next_wave'):
		state_machine.set_value('is_next_wave', false)
	
	create_level_enemy(level)

	available_skills = fetch_random_skills(level)
	available_rings = fetch_random_rings(level)
	available_equipments = state_machine.get_value('player').get('equipment_list')
	new_equipment = null
	new_ring = null
	new_skill = null
	
	if !agent.ui_layer.ring_choose.is_connected(ring_choosen):
		agent.ui_layer.ring_choose.connect(ring_choosen)
	
	if !agent.ui_layer.skill_choose.is_connected(skill_choosen):
		agent.ui_layer.skill_choose.connect(skill_choosen)
		
	if !agent.ui_layer.equipment_choose.is_connected(equipment_choosen):
		agent.ui_layer.equipment_choose.connect(equipment_choosen)
		
	if !agent.ui_layer.next_wave.is_connected(next_wave):
		agent.ui_layer.next_wave.connect(next_wave)
		
	
	#for i in range(1, 10):
	var available_equipment = fetch_random_equipment(level)
	print("隨機刷出裝備：" + str(available_equipment.get('name')) + ", 等級為：" + str(available_equipment.get('level')))
	
	if available_equipment:
		available_equipments.append(available_equipment)
		new_equipment = available_equipment
		await state_machine.get_value('player').add_equipment_to_list(available_equipment.get('id'))
	
	agent.ui_layer.input_show_equipment_data(state_machine.get_value('player'))
	show_rings_selection()
	show_skills_selection()
	
	remove_actor("enemy")
	remove_actor("player")

func update(delta):
	#開始下一場對戰
	if state_machine.has_value('is_next_wave'):
		is_next_wave = state_machine.get_value('is_next_wave')	
	if is_next_wave:
		transform_to(StateEnum.GAME_STATE_TYPE.PLAYING)

func exit():
	agent.ui_layer.hide_ui_ready()
	
	state_machine.set_value('is_next_wave', false)
	is_next_wave = state_machine.get_value('is_next_wave')
	
	reset_actor('player')

func next_wave():
	if new_equipment and new_ring and new_skill:
		state_machine.set_value('is_next_wave', true)
	else :
		state_machine.set_value('is_next_wave', false)

func skill_choosen(number:int):
	new_skill = available_skills[number-1]
	print("玩家選擇技能：" + new_skill.name)

func ring_choosen(number:int):
	new_ring = available_rings[number-1]
	print("玩家選擇光環：" + new_ring.name)
	
func equipment_choosen(equipments_index:int):
	if equipments_index >= 0 and equipments_index < available_equipments.size():
		new_equipment = available_equipments[equipments_index]
		print("玩家選擇裝備：" + new_equipment.name)
	else :
		print("無效的裝備索引：%d" % equipments_index)

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

func remove_actor(aim:String):
	for child in agent.get_children():
		if child.name == aim:
			agent.remove_child(child)
			
func reset_actor(aim:String):

	if aim == 'player':
		await state_machine.get_value(aim).equipment_change(new_equipment.get('id'))
		await state_machine.get_value(aim).build_new_ring(new_ring.get('id'))
		await state_machine.get_value(aim).skill_change(new_skill.get('id'))
		var max_health = state_machine.get_value(aim)._get_max_health()
		state_machine.get_value(aim).set('health', max_health)
		
	else :
		print("錯誤的節點名稱")
		return
		
func create_level_enemy(level:int):
	var enemy_data = db.select_rows("actor", "level = " + str(level), ["*"])
	if enemy_data.size() > 0:
		var rand_enemy_id:int = randi() % enemy_data.size()
		var rand_enemy:Actor = Actor.new(enemy_data[rand_enemy_id])
		rand_enemy.set('name', 'enemy')
		state_machine.set_value('enemy', rand_enemy)
		
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
