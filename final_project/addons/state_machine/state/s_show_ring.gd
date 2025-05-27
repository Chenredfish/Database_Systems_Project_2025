extends BaseState
class_name s_Show_Ring

var hide_show_ring:bool = false
var from_playing:bool = false
var from_ready:bool = false

func enter(_msg:Dictionary = {}):
	print("into state of s_Show_Ring")
	
	if !agent.ui_layer.exit_show_ring.is_connected(exit_s_show_ring):
		agent.ui_layer.exit_show_ring.connect(exit_s_show_ring)
	
	agent.ui_layer.show_ui_show_ring()
	
	var aim = str(state_machine.get_value('to_show_aim'))
	print("to show " + aim)
	
	if state_machine.has_value('from_playing'):
		from_playing = state_machine.get_value('from_playing')
	if state_machine.get_value('from_ready'):
		from_ready = state_machine.get_value('from_ready')
	
	agent.ui_layer.input_show_ring_data(state_machine.get_value(aim))

func update(delta):
	if state_machine.has_value('from_playing'):
		from_playing = state_machine.get_value('from_playing')
		
	if state_machine.has_value('from_ready'):
		from_ready = state_machine.get_value('from_ready')
		
	if state_machine.has_value('hide_show_ring'):
		hide_show_ring = state_machine.get_value('hide_show_ring')
		
	if hide_show_ring:
		if from_playing:
			transform_to(StateEnum.GAME_STATE_TYPE.PLAYING)
		elif from_ready:
			transform_to(StateEnum.GAME_STATE_TYPE.READY)
		else:
			print("無法關閉show_ring，因為無法確認show_ring前的狀態")
	
func exit():
	agent.ui_layer.hide_ui_show_ring()
	
	from_playing = false
	state_machine.set_value('from_playing', from_playing)
	from_ready = false
	state_machine.set_value('from_ready', from_ready)
	hide_show_ring = false
	state_machine.set_value('hide_show_ring', hide_show_ring)

func exit_s_show_ring():
	state_machine.set_value('hide_show_ring', true)
