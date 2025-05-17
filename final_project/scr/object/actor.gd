# Actor.gd
extends Resource
class_name Actor

# 宣告屬性
var id: int
var name: String
var element: float
var health: int = 100
var attack_point: int = 10
var magic_point: int = 10
var attack_defence: int = 5
var magic_defence: int = 5
var level: int = 1

# 初始化方法
func _init(_id: int, _name: String, _element: float, _health: int = 100, _attack_point: int = 10,
			_magic_point: int = 10, _attack_defence: int = 5, _magic_defence: int = 5, _level: int = 1) -> void:
	self.id = _id
	self.name = _name
	self.element = _element
	self.health = _health
	self.attack_point = _attack_point
	self.magic_point = _magic_point
	self.attack_defence = _attack_defence
	self.magic_defence = _magic_defence
	self.level = _level

# 用來顯示角色資訊
func describe() -> String:
	return "Actor(%s): %s | Element: %s | HP: %d, ATK: %d, MP: %d, DEF: %s, MDEF: %d, LVL: %d" % [
		id, name, element, health, attack_point, magic_point, attack_defence, magic_defence, level
	]
