class_name Equipment

var id: int
var name: String
var attack_defence: int
var magic_defence: int
var level: int

func _init(data: Dictionary) -> void:
	id = data.get("id", 0)
	name = data.get("name", "")
	attack_defence = data.get("attack_defence", 0)
	magic_defence = data.get("magic_defence", 0)
	level = data.get("level", 0)