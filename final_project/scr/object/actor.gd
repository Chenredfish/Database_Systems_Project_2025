# Actor.gd
extends Node2D
class_name Actor

# 宣告屬性
var id: int
var _name: String
var element: String
var health: int 
var attack_point: int 
var magic_point: int 
var attack_defence: int 
var magic_defence: int 
var level: int 

var db := SQLite.new()
var equipment: Equipment
var skills: Skill
var rings: Array[Ring] = []

# 初始化方法
func _init(data: Dictionary) -> void:
	id = data.get("id", 0)
	_name = data.get("name", "")
	element = data.get("element", "")
	health = data.get("health", 0)
	attack_point = data.get("attack_point,0 )
	magic_point = data.get("magic_point", 0)
	attack_defence = data.get("attack_defence", 0)
	magic_defence = data.get("magic_defence", 0)
	level = data.get("level", 0)

	
func open_data():
	db.path = "res://data/game.db"
	if not db.open_db():
		push_error("無法開啟資料庫")
		return
		
func equipment_change(equipment_id: int) -> void:
	var query = "SELECT id, name, attack_defence, magic_defence FROM equipment WHERE id = ?"
	db.query_with_bindings(query, [equipment_id])

	if db.query_result.size() == 0:
		print("找不到指定 ID 的裝備")
		return

	var row = db.query_result[0]

	var new_equipment = Equipment.new()
	new_equipment.id = row["id"]
	new_equipment.name = row["name"]
	new_equipment.attack_defence = row["attack_defence"]
	new_equipment.magic_defence = row["magic_defence"]

	equipment = new_equipment

	print("%s 裝備了 %s" % [_name, new_equipment.name])


func skill_change(skill_id: int) -> void:
	var query = "SELECT id, name, power, cost FROM skill WHERE id = ?"
	db.query_with_bindings(query, [skill_id])

	if db.query_result.size() == 0:
		print("找不到指定 ID 的技能")
		return

	var row = db.query_result[0]

	var new_skill = Skill.new()
	new_skill.id = row["id"]
	new_skill.name = row["name"]
	new_skill.power = row["power"]
	new_skill.cost = row["cost"]

	skills = new_skill

	print("%s 學會了 %s" % [_name, new_skill.name])

func new_ring(ring_id: int):#增加新的狀態
	var query = "SELECT id, name, attack_power, magic_power, attack_defence, magic_defence, health FROM ring WHERE id = ?"
	db.query_with_bindings(query, [ring_id])

	if db.query_result.size() == 0:
		push_error("找不到指定 ID 的狀態")
		return

	var row = db.query_result[0]  # 是一個 Array 對應欄位順序

	var new_ring = Ring.new()
	new_ring.id = row["id"]
	new_ring.name = row["name"]
	new_ring.attack_power = row["attack_power"]
	new_ring.magic_power = row["magic_power"]
	new_ring.attack_defence = row["attack_defence"]
	new_ring.magic_defence = row["magic_defence"]
	new_ring.health = row["health"]

	rings.append(new_ring)
	print("已新增狀態：", new_ring.name) 

func get_element_multiplier_from_db(attacker_element: String, target_element: String) -> float:#屬性判定	
	var query = "SELECT advantage FROM element WHERE name = ?"
	db.query_with_bindings(query, [attacker_element])

	if db.query_result.size() == 0:
		return 1.0

	var row = db.query_result[0]  # 取得第一筆資料（應該是 Dictionary 或 Array，取決於你的資料庫插件）

	var advantage = row["advantage"]  # ✅ 使用欄位名稱存取

	if target_element == advantage:
		return 1.5
	else:
		return 1.0

func get_combined_ring_state()->Dictionary:#當前狀態加成
	var result = {
		"attack_power" = 0.0,
	 	"magic_power" = 0.0,
	 	"attack_defence" = 0.0,
	 	"magic_defence" = 0.0,
	 	"health" = 0.0
	}
	
	for ring in rings:
		result["attack_power"] += ring.attack_power
		result["magic_power"] += ring.magic_power
		result["attack_defence"] += ring.attack_defence
		result["magic_defence"] += ring.magic_defence
		result["health"] += ring.health
	
	return result

func _get_attack_damage():#物理傷害
	var ring_state = get_combined_ring_state()
	var attack_damege = attack_point * (1 + ring_state["attack_power"])
	return attack_damege

func _get_magic_damage():#魔法傷害
	var ring_state = get_combined_ring_state()
	var magic_damege = self.magic_point * (1 + ring_state["magic_power"])
	return magic_damege

func _get_attack_defence():#物理減傷
	var ring_state = get_combined_ring_state()
	var defence_number = (equipment.attack_defence + self.attack_defence) * (1 + ring_state["attack_defence"])
	var defence = defence_number / (100 + defence_number)
	return defence
	
func _get_magic_defence():#魔法減傷
	var ring_state = get_combined_ring_state()
	var magic_defence_number = (equipment.magic_defence + self.magic_defence) * (1 + ring_state["magic_defence"])
	var magic_defence = magic_defence_number / (100 + magic_defence_number)
	return magic_defence

func _get_max_health():#最大血量
	var ring_state = get_combined_ring_state()
	var health_now = self.health *(1 + ring_state["health"])
	return health_now

func damage_calculate(target:Actor, is_magic: bool = 0) -> String:#傷害計算包含血量變更
	var attacker_damage: int
	var target_defence: float
	var skill_power = skills.power
	var attacker_element = skills.element
	var target_element = target.element
	var element_percent = get_element_multiplier_from_db(attacker_element, target_element)

	if is_magic:
		attacker_damage =_get_magic_damage()
		target_defence = target._get_magic_defence()
	else:
		attacker_damage = _get_attack_damage()
		target_defence = target._get_attack_defence()
	
	var final_damage = attacker_damage * element_percent * skill_power	
	
	var real_damage = final_damage * (1 - target_defence)
	
	target.health = max(0, target.health - real_damage)
	
	if target.health <= 0:
		return "%s has been defeated." %target._name
	else:
		return "%s took %d damage." %[target._name, int(real_damage)]
	
