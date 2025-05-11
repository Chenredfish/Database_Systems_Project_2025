extends BaseState
class_name s_Playing

var to_manage_main:bool = false


func enter(_msg:Dictionary = {}):
	print("into state of s_Playing")
	
	agent.ui_layer.show_ui_playing()
	if !agent.ui_layer.exit_playing.is_connected(exit_playing):
		agent.ui_layer.exit_playing.connect(exit_playing)

func update(delta):
	
	
	if state_machine.has_value('to_manage_main'):
		to_manage_main = state_machine.get_value('to_manage_main')
		
	if to_manage_main:
		transform_to(StateEnum.GAME_STATE_TYPE.MANAGE_MAIN)
func exit():
	agent.ui_layer.hide_ui_playing()
	
	to_manage_main = false
	state_machine.set_value('to_manage_main', to_manage_main)

func exit_playing():
	state_machine.set_value('to_manage_main', true)
