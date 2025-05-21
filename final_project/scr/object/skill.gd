class_name Skill

var id: int
var name: String
var element: String
var power: float 
var cooldown: int 
var level: int 
var is_magic: int 

func _init(data: Dictionary) -> void:
	id = data.get("id", 0)
	name = data.get("name", "")
	element = data.get("element", "")
	power = data.get("power", 0.0)
	cooldown = data.get("cooldown",0 )
	level = data.get("level", 0)
	is_magic = data.get("is_magic",0)
