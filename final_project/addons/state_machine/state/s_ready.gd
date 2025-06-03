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
var to_show_ring:bool = false

# 載入 Equipment 類別
const Equipment = preload("res://scr/object/equipment.gd")

func enter(_msg: Dictionary = {}):
	print("into state of s_Ready")
	
	var db_dir = "user://data"
	var db_path = db_dir + "/game.db"
	# 確保 user://data 資料夾存在
	if not DirAccess.dir_exists_absolute(db_dir):
		DirAccess.make_dir_recursive_absolute(db_dir)
	# 如果 user://data/game.db 不存在，從 res://data/game.db 複製過去
	if not FileAccess.file_exists(db_path):
		var src = FileAccess.open("res://data/game.db", FileAccess.READ)
		var dst = FileAccess.open(db_path, FileAccess.WRITE)
		dst.store_buffer(src.get_buffer(src.get_length()))
		src.close()
		dst.close()
	db.path = db_path
	db.open_db()

	var level = state_machine.get_value("level")
	
	create_level_enemy(level)
	display_next_enemy_element() # 顯示下一關敵人的屬性
	var player = state_machine.get_value("player")
	
	# 這裡複製玩家裝備列表，避免直接操作玩家資料
	available_skills = fetch_random_skills(level)
	available_rings = fetch_random_rings(level)
	available_equipments = state_machine.get_value('player').get('equipment_list').duplicate()
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
		
	if !agent.ui_layer.to_show_ring.is_connected(show_ring):
		agent.ui_layer.to_show_ring.connect(show_ring)
		
	
	var available_equipment = fetch_random_equipment(level)
	if available_equipment:
		print("隨機刷出裝備：" + str(available_equipment.get('name')) + ", 等級為：" + str(available_equipment.get('level')))
		available_equipments.append(available_equipment)
		await state_machine.get_value('player').add_equipment_to_list(available_equipment.get('id'))
		
	if !state_machine.has_value('is_next_wave'):
		state_machine.set_value('is_next_wave', false)
	
	if !state_machine.has_value('to_show_ring'):
		state_machine.set_value('to_show_ring', false)
	
	# 將 available_equipments 傳給 UI 顯示
	agent.ui_layer.input_show_equipment_data(available_equipments)
	show_rings_selection()
	show_skills_selection()
	
	remove_actor("enemy")
	remove_actor("player")
	
	var max_health = state_machine.get_value('player')._get_max_health()
	state_machine.get_value('player').set('health', max_health)
	agent.ui_layer.show_ui_ready(state_machine.get_value("player"))

func update(delta):
	#開始下一場對戰
	if state_machine.has_value('is_next_wave'):
		is_next_wave = state_machine.get_value('is_next_wave')	
	if is_next_wave:
		transform_to(StateEnum.GAME_STATE_TYPE.PLAYING)
		
	if state_machine.has_value('to_show_ring'):
		to_show_ring = state_machine.get_value('to_show_ring')	
	if to_show_ring:
		transform_to(StateEnum.GAME_STATE_TYPE.SHOW_RING)

func exit():
	agent.ui_layer.hide_ui_ready()
	
	if is_next_wave == true:
		await reset_actor('player')
		await reset_actor('enemy')
	
	state_machine.set_value('is_next_wave', false)
	is_next_wave = state_machine.get_value('is_next_wave')
	
	to_show_ring = false
	state_machine.set_value('to_show_ring', to_show_ring)
	agent.ui_layer.to_show_ring.disconnect(show_ring)
	
	record_round()	

func next_wave():
	if new_equipment and new_ring and new_skill:
		state_machine.set_value('is_next_wave', true)
	else :
		state_machine.set_value('is_next_wave', false)
		
func show_ring(aim:String):
	state_machine.set_value('to_show_ring', true)
	state_machine.set_value('to_show_aim', aim)
	state_machine.set_value('from_ready', true)

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
		
		print("玩家裝備了" + new_skill.get('name') + new_ring.get('name') + new_equipment.get('name'))
	elif aim == 'enemy':
		var enemy = state_machine.get_value('enemy')
		var level = enemy.level
		var enemy_equipment = fetch_random_equipment(level)
		var rand_ring = null	
		if enemy_equipment:
			await enemy.add_equipment_to_list(enemy_equipment.get('id'))
			await enemy.equipment_change(enemy_equipment.get('id'))
		var enemy_rings = fetch_random_rings(level)
		if enemy_rings.size() > 0:
			rand_ring = enemy_rings[randi() % enemy_rings.size()]
			await enemy.build_new_ring(rand_ring.get('id'))
		var max_health = enemy._get_max_health()
		enemy.set('health', max_health)
		
		print("敵人裝備了" + enemy_equipment.get('name') + rand_ring.get('name'))
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
		show_end_game()

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

func display_next_enemy_element():
	var next_enemy_actor = state_machine.get_value('enemy')
	var enemy_element_texture_rect = agent.ui_layer.ui_ready.get_node("Show_elements/TextureRect")

	if enemy_element_texture_rect and next_enemy_actor:
		var enemy_element = next_enemy_actor.get('element') # element從 Actor 物件中獲取
		var element_icon_path = ""

		match enemy_element:
			"火":
				element_icon_path = "res://assets/elements_icon/1.png"
			"水":
				element_icon_path = "res://assets/elements_icon/2.png"
			"草":
				element_icon_path = "res://assets/elements_icon/3.png"
			"光":
				element_icon_path = "res://assets/elements_icon/4.png"
			"暗":
				element_icon_path = "res://assets/elements_icon/5.png"
			_:
				push_warning("未知的敵人元素屬性: " + str(enemy_element) + " 或未設定對應圖示。")
				element_icon_path = "" 
				
		if !element_icon_path.is_empty():
			var element_texture = load(element_icon_path)
			if element_texture:
				enemy_element_texture_rect.texture = element_texture
				print("下一關敵人的屬性：" + enemy_element)
			else:
				push_warning("無法載入敵人屬性: " + element_icon_path)
		else:
			push_warning("未為敵人元素設定圖示路徑。")
	else:
		push_warning("無法找到 UI Ready 中的敵人屬性顯示節點 (TextureRect) 或敵人 Actor 物件不存在。")


func record_round():
	var game_id:int = state_machine.get_value('game_id')
	var round_id:int = state_machine.get_value('round_id')
	var player_level:int = state_machine.get_value('level')
	var player_equipment_id:int = new_equipment.get('id')
	var player_skill_id:int = new_skill.get('id')
	var skill_choice_id:Array[int] = [available_skills[0].get('id'), available_skills[1].get('id'), available_skills[2].get('id')]
	var player_ring_id:int = new_ring.get('id')
	var ring_choice_id:Array[int] = [available_rings[0].get('id'), available_rings[1].get('id'), available_rings[2].get('id')]
	
	var enemy:Actor = state_machine.get_value('enemy')
	var enemy_id:int = enemy.get('id')
	var enemy_skill_id:int = enemy.get('skill').get('id')
	var enemy_equipment_id:int = enemy.get('equipment').get('id')
	var enemy_ring_id:int = enemy.get('rings')[0].get('id')
	
	var sql = "INSERT INTO record (game_id, round_id, player_level, player_equipment_id, player_skill_id, skill_choice_id_1, skill_choice_id_2, skill_choice_id_3, player_ring_id, ring_choice_id_1, ring_choice_id_2, ring_choice_id_3, enemy_id, enemy_skill_id, enemy_equipment_id, enemy_ring_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
	var values = [
		game_id, round_id, player_level, player_equipment_id, player_skill_id,
		skill_choice_id[0], skill_choice_id[1], skill_choice_id[2],
		player_ring_id, ring_choice_id[0], ring_choice_id[1], ring_choice_id[2],
		enemy_id, enemy_skill_id, enemy_equipment_id, enemy_ring_id
	]
	print(values)
	print(db.query_with_bindings(sql, values))
	
	

	print("已紀錄本回合資料到資料庫")
	state_machine.set_value('round_id', round_id+1)
	

func show_end_game():
	var you_win_label = Label.new()
	you_win_label.text = "遊戲結束，恭喜通關！"
	you_win_label.add_theme_color_override("font_color", Color.AQUA)
	#you_win_label.set_anchors_and_margins_preset(Control.PRESET_CENTER)
	you_win_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	you_win_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	you_win_label.set_size(Vector2(400, 100))
	#位置設定在畫面正中央
	you_win_label.set_position(Vector2(-400 + 1920/2, -100 + 1080/2))
	you_win_label.scale = Vector2(2, 2)
	agent.ui_layer.ui_ready.add_child(you_win_label)
	print("顯示失敗畫面")
