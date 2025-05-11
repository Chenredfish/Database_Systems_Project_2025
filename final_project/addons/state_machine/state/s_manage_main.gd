extends BaseState
class_name s_Manage_Main

func enter(_msg:Dictionary = {}):
	print("into state of s_Manage_Main")
	
	agent.ui_layer.show_ui_manage_main()

func update(delta):
	pass
	
func exit():
	pass
