extends Resource
class_name Ring

var id: int
var name: String
var attack_power: int = 0
var magic_power: int = 0
var attack_defence: int = 0
var magic_defence: int = 0
var health: int = 0
var level: int = 1

func _init(_id: int, _name: String, _attack_power: int = 0, _magic_power: int = 0,
		   _attack_defence: int = 0, _magic_defence: int = 0,
		   _health: int = 0, _level: int = 1) -> void:
	self.id = _id
	self.name = _name
	self.attack_power = _attack_power
	self.magic_power = _magic_power
	self.attack_defence = _attack_defence
	self.magic_defence = _magic_defence
	self.health = _health
	self.level = _level

func describe() -> String:
	return "Ring(%s): %s | ATK: %d, MATK: %d, DEF: %d, MDEF: %d, HP: %d, LVL: %d" % [
		id, name, attack_power, magic_power, attack_defence, magic_defence, health, level
	]
