extends BaseState
class_name s_Show_Ring

var hide_show_ring:bool = false

func enter(_msg:Dictionary = {}):
	print("into state of s_Show_Ring")
	
	if !agent.ui_layer.exit_show_ring.is_connected(exit_s_show_ring):
		agent.ui_layer.exit_show_ring.connect(exit_s_show_ring)
	
	agent.ui_layer.show_ui_show_ring()
	agent.ui_layer.input_show_ring_data(state_machine.get_value('player'))

func update(delta):
	if state_machine.has_value('hide_show_ring'):
		hide_show_ring = state_machine.get_value('hide_show_ring')
		
	if hide_show_ring:
		transform_to(StateEnum.GAME_STATE_TYPE.PLAYING)
	
func exit():
	agent.ui_layer.hide_ui_show_ring()
	
	hide_show_ring = false
	state_machine.set_value('hide_show_ring', hide_show_ring)

func exit_s_show_ring():
	state_machine.set_value('hide_show_ring', true)
