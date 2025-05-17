extends Resource
class_name Skill

var id: int
var name: String
var element: String
var power: float = 1.0
var cooldown: int = 0
var level: int = 1
var ismagic: int = 0

func _init(_id: int, _name: String, _element: String, _power: float = 1.0,
		   _cooldown: int = 0, _level: int = 1, _ismagic: int = 0) -> void:
	self.id = _id
	self.name = _name
	self.element = _element
	self.power = _power
	self.cooldown = _cooldown
	self.level = _level
	self.ismagic = _ismagic

func describe() -> String:
	return "Skill(%s): %s | Element: %s | Power: %.1f, Cooldown: %d, Level: %d, Magic: %d" % [
		id, name, element, power, cooldown, level, ismagic
	]
