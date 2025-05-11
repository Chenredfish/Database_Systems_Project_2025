extends BaseState
class_name s_Manage_Main

var to_playing:bool = false
var to_manage_ring:bool = false

func enter(_msg:Dictionary = {}):
	print("into state of s_Manage_Main")
	
	agent.ui_layer.show_ui_manage_main()
	if !agent.ui_layer.exit_manage_main.is_connected(exit_manage_main):
		agent.ui_layer.exit_manage_main.connect(exit_manage_main)
	if !agent.ui_layer.to_manage_ring.is_connected(change_state_manage_ring):
		agent.ui_layer.to_manage_ring.connect(change_state_manage_ring)

func update(delta):

	if state_machine.has_value('to_playing'):
		to_playing = state_machine.get_value('to_playing')
		
	if to_playing:
		transform_to(StateEnum.GAME_STATE_TYPE.PLAYING)
		
	if state_machine.has_value('to_manage_ring'):
		to_manage_ring = state_machine.get_value('to_manage_ring')
		
	if to_manage_ring:
		transform_to(StateEnum.GAME_STATE_TYPE.MANAGE_CHANGE_RING)
	
func exit():
	to_playing = false
	state_machine.set_value('to_playing', to_playing)
	
	to_manage_ring = false
	state_machine.set_value('to_manage_ring', to_manage_ring)
	
	agent.ui_layer.hide_ui_manage_main()

#按鈕對應到的callable function
func exit_manage_main():
	state_machine.set_value('to_playing', true)
	
func change_state_manage_ring():
	state_machine.set_value('to_manage_ring', true)
