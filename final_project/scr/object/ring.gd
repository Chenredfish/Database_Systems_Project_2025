class_name Ring

var id: int
var name: String
var attack_power: int 
var magic_power: int 
var attack_defence: int 
var magic_defence: int
var health: int 
var level: int

func _init(_id: int, _name: String, _attack_power: int, _magic_power: int,
		   _attack_defence: int, _magic_defence: int,
		   _health: int, _level: int ) -> void:
	self.id = _id
	self.name = _name
	self.attack_power = _attack_power
	self.magic_power = _magic_power
	self.attack_defence = _attack_defence
	self.magic_defence = _magic_defence
	self.health = _health
	self.level = _level
