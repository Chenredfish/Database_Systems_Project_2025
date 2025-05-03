extends BaseState
class_name s_Playing

var to_manage_main:bool = false

func enter(_msg:Dictionary = {}):
	print("into state of s_Playing")

func update(delta):
	
	"""state_machine.set_value('to_manage_main', true)"""
	
	if state_machine.has_value('to_manage_main'):
		to_manage_main = state_machine.get_value('to_manage_main')
		
	if to_manage_main:
		transform_to(StateEnum.GAME_STATE_TYPE.MANAGE_MAIN)
func exit():
	
	to_manage_main = false
	state_machine.set_value('to_manage_main', to_manage_main)
