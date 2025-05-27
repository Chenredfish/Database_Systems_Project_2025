extends BaseState
class_name s_Manage_Change

var aim:String = ""
var to_playing:bool = false

func enter(_msg:Dictionary = {}):
	print("into state of s_Manage_Change")
	
	aim = state_machine.get_value('to_manage_something')
	
	print("show " + aim + " data")
	
	if !agent.ui_layer.exit_manage_change_something.is_connected(exit_manage_change_something):
		agent.ui_layer.exit_manage_change_something.connect(exit_manage_change_something)
	
	match aim:
		"skill":
			agent.ui_layer.show_ui_manage_change_skill()
		"equipment":
			agent.ui_layer.show_ui_manage_equipment()
		"actor":
			agent.ui_layer.show_ui_manage_change_actor()
		"record":
			agent.ui_layer.show_ui_record()

func update(delta):
	if state_machine.has_value('to_playing'):
		to_playing = state_machine.get_value('to_playing')
		
	if to_playing:
		transform_to(StateEnum.GAME_STATE_TYPE.PLAYING)
	
func exit():
	aim = ""
	state_machine.set_value('to_manage_something', aim)
	
	agent.ui_layer.hide_ui_manage_change_actor()
	agent.ui_layer.hide_ui_manage_change_skill()
	agent.ui_layer.hide_ui_manage_equipment()
	agent.ui_layer.hide_ui_record()
	
func exit_manage_change_something():
	state_machine.set_value('to_playing', true)
