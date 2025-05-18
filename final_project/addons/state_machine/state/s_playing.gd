extends BaseState
class_name s_Playing

var to_manage_main:bool = false
var to_show_ring:bool = false


func enter(_msg:Dictionary = {}):
	print("into state of s_Playing")
	
	agent.ui_layer.show_ui_playing()
	if !agent.ui_layer.exit_playing.is_connected(exit_playing):
		agent.ui_layer.exit_playing.connect(exit_playing)
	if !agent.ui_layer.to_show_ring.is_connected(show_ring):
		agent.ui_layer.to_show_ring.connect(show_ring)

func update(delta):
	
	#切換管理者介面
	if state_machine.has_value('to_manage_main'):
		to_manage_main = state_machine.get_value('to_manage_main')
		
	if to_manage_main:
		transform_to(StateEnum.GAME_STATE_TYPE.MANAGE_MAIN)
	#切換顯示ring的介面
	if state_machine.has_value('to_show_ring'):
		to_show_ring = state_machine.get_value('to_show_ring')
		
	if to_show_ring:
		transform_to(StateEnum.GAME_STATE_TYPE.SHOW_RING)
func exit():
	agent.ui_layer.hide_ui_playing()
	
	to_manage_main = false
	state_machine.set_value('to_manage_main', to_manage_main)
	
	to_show_ring = false
	state_machine.set_value('to_show_ring', to_show_ring)

func exit_playing():
	state_machine.set_value('to_manage_main', true)

func show_ring():
	state_machine.set_value('to_show_ring', true)
