class_name Equipment

var id: int
var name: String
var attack_defence: int
var magic_defence: int
var level: int

func _init(_id: int, _name: String, _attack_defence: int,
		   _magic_defence: int, _level: int) -> void:
	self.id = _id
	self.name = _name
	self.attack_defence = _attack_defence
	self.magic_defence = _magic_defence
	self.level = _level
