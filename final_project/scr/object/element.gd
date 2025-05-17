extends Resource
class_name Element

var name: String
var advantage: String
var disadvantage: String

func _init(_name: String, _advantage: String = "", _disadvantage: String = "") -> void:
	self.name = _name
	self.advantage = _advantage
	self.disadvantage = _disadvantage

func describe() -> String:
	return "Element: %s | Advantage: %s | Disadvantage: %s" % [
		name, advantage, disadvantage
	]
		
