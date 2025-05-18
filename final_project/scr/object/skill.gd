class_name Skill

var id: int
var name: String
var element: String
var power: float 
var cooldown: int 
var level: int 
var ismagic: int 

func _init(_id: int, _name: String, _element: String, _power: float ,
		   _cooldown: int, _level: int, _ismagic: int) -> void:
	self.id = _id
	self.name = _name
	self.element = _element
	self.power = _power
	self.cooldown = _cooldown
	self.level = _level
	self.ismagic = _ismagic
