extends BaseState
class_name s_Manage_Change

var aim:String = ""

func enter(_msg:Dictionary = {}):
	print("into state of s_Manage_Change")
	
	aim = state_machine.get_value('to_manage_something')
	
	print("show " + aim)

func update(delta):
	pass
	
func exit():
	aim = ""
	state_machine.set_value('to_manage_something', aim)
