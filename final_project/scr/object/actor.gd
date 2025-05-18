# Actor.gd
extends Node2D
class_name Actor

# 宣告屬性
var id: int
var _name: String
var element: float
var health: int 
var attack_point: int 
var magic_point: int 
var attack_defence: int 
var magic_defence: int 
var level: int 

var equipment: Equipment
var skills: Skill
var rings: Array[Ring] = []
# 初始化方法
func _init(_id: int, _name: String, _element: float, _health: int , _attack_point: int ,
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

func equipment_change():#裝備的變更
	pass

func skill_change():#技能的變更
	pass

func new_ring():#增加新的狀態
	pass

func _get_attack_damege():#物理傷害
	pass

func _get_magic_damege():#魔法傷害
	pass

func _get_attack_defense():#物理減傷
	pass

func _get_magic_defense():#魔法減傷
	pass

func damege_calculate():#傷害計算包含血量變更
	pass
