class_name Ring

var id: int
var name: String
var attack_power: int 
var magic_power: int 
var attack_defence: int 
var magic_defence: int
var health: int 
var level: int

func _init(data: Dictionary) -> void:
	id = data.get("id", 0)
	name = data.get("name", "")
	health = data.get("health", 0)
	attack_power = data.get("attack_power",0 )
	magic_power = data.get("magic_power", 0)
	attack_defence = data.get("attack_defence", 0)
	magic_defence = data.get("magic_defence", 0)
	level = data.get("level", 0)
