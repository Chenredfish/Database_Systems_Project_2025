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
func _init(_id: int, _name: String, _element: String, _health: int , _attack_point: int ,
			_magic_point: int , _attack_defence: int , _magic_defence: int , _level: int) -> void:
	self.id = _id
	self.name = _name
	self.element = _element
	self.health = _health
	self.attack_point = _attack_point
	self.magic_point = _magic_point
	self.attack_defence = _attack_defence
	self.magic_defence = _magic_defence
	self.level = _level
	db.path = "res://data/game.db"
	
func equipment_change(new_equipment: Equipment) ->void:#裝備的變更
	equipment = new_equipment
	print("%s 裝備了 %s" %[_name, new_equipment.name])

func skill_change(new_skill: Skill) ->void:#技能的變更
	skills = new_skill
	print("%s 學會了 %s" %[_name, new_skill.name])	

func new_ring(ring_id: int):#增加新的狀態
	if not db.open_db():
		push_error("無法開啟資料庫")
		return
	
	var query = "SELECT id, name, attack_power, magic_power, attack_defence, magic_defence, health FROM ring WHERE id = ?"
	db.query_with_bindings(query, [ring_id])
	var row = db.fetch_array()
	
	if row.size() == 0:
		push_error("找不到指定 ID 的 狀態")
		return

	var new_ring = Ring.new()
	new_ring.id = row[0]
	new_ring.name = row[1]
	new_ring.attack_power = row[2]
	new_ring.magic_power = row[3]
	new_ring.attack_defence = row[4]
	new_ring.magic_defence = row[5]
	new_ring.health = row[6]

	rings.append(new_ring)
	print("已新增狀態：", new_ring.name)

func get_element_multiplier_from_db(attacker_element: String, target_element: String) -> float:#屬性判定
	if not db.open_db():
		push_error("無法開啟資料庫")
		return 1.0
	
	var query = "SELECT advantage FROM element WHERE name = ?"
	db.query_with_bindings(query, [attacker_element])
	var row = db.fetch_array()
	
	if row.size()==0:
		return 1.0
		
	var advantage = row[0]
	
	if target_element == advantage:
		return 1.5
	else: 
		return 1.0

func get_combined_ring_state()->Dictionary:#當前狀態加成
	var result = {
		"attack_power" = 0.0,
	 	"magic_power" = 0.0,
	 	"attack_defense" = 0.0,
	 	"magic_defense" = 0.0,
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

func _get_attack_defense():#物理減傷
	var ring_state = get_combined_ring_state()
	var defense_number = (equipment.attack_defence + self.attack_defence) * (1 + ring_state["attack_defense"])
	var defense = defense_number / (100 + defense_number)
	return defense
	
func _get_magic_defense():#魔法減傷
	var ring_state = get_combined_ring_state()
	var magic_defense_number = (equipment.magic_defence + self.magic_defence) * (1 + ring_state["magic_defense"])
	var magic_defense = magic_defense_number / (100 + magic_defense_number)
	return magic_defense

func _get_max_health():#最大血量
	var ring_state = get_combined_ring_state()
	var health_now = self.health *(1 + ring_state["health"])
	return health_now

func damage_calculate(target:Actor, is_magic: bool = false) -> String:#傷害計算包含血量變更
	var attacker_damage: int
	var target_defense: float
	var attacker_element = self.element
	var target_element = target.element
	var element_percent = get_element_multiplier_from_db(attacker_element, target_element)

	if is_magic:
		attacker_damage =_get_magic_damage()
		target_defense = target._get_magic_defense()
	else:
		attacker_damage = _get_attack_damage()
		target_defense = target._get_attack_defense()
	
	var final_damage = attacker_damage * element_percent	
	
	var real_damage = final_damage * (1 - target_defense)
	
	target.health = max(0, target.health - real_damage)
	
	if target.health <= 0:
		return "%s has been defeated." %target._name
	else:
		return "%s took %d damage." %[target._name, int(real_damage)]
	
