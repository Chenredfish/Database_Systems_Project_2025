extends Resource
class_name Equipment

var id: int
var name: String
var attack_defence: int = 0
var magic_defence: int = 0
var level: int = 1

func _init(_id: int, _name: String, _attack_defence: int = 0,
		   _magic_defence: int = 0, _level: int = 1) -> void:
	self.id = _id
	self.name = _name
	self.attack_defence = _attack_defence
	self.magic_defence = _magic_defence
	self.level = _level

func describe() -> String:
	return "Equipment(%s): %s | DEF: %d, MDEF: %d, Level: %d" % [
		id, name, attack_defence, magic_defence, level
	]
