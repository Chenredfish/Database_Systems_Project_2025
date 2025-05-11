extends BaseState
class_name s_Manage_Change_Ring

var to_playing:bool = false

func enter(_msg:Dictionary = {}):
	print("into state of s_Manage_Change_Ring")
	
	agent.ui_layer.show_ui_manage_change_ring()
	
	if !agent.ui_layer.exit_manage_change_ring.is_connected(exit_manage_change_ring):
		agent.ui_layer.exit_manage_change_ring.connect(exit_manage_change_ring)

func update(delta):

	if state_machine.has_value('to_playing'):
		to_playing = state_machine.get_value('to_playing')
		
	if to_playing:
		transform_to(StateEnum.GAME_STATE_TYPE.PLAYING)
	
func exit():
	agent.ui_layer.hide_ui_manage_change_ring()
	
	to_playing = false
	state_machine.set_value('to_playing', to_playing)

func exit_manage_change_ring():
	state_machine.set_value('to_playing', true)
