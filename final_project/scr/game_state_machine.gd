extends BaseStateMachine
class_name GameStateMachine

const StateEnum = preload("res://state_enum.gd")
'''
func enter(_msg:Dictionary = {}):

func update(delta:float)->void:
	
func exit():

'''

func _ready():
	add_state(StateEnum.GAME_STATE_TYPE.PLAYING, s_Playing.new(self))
	add_state(StateEnum.GAME_STATE_TYPE.READY, s_Ready.new(self))
	add_state(StateEnum.GAME_STATE_TYPE.SHOW_RING, s_Show_Ring.new(self))
	add_state(StateEnum.GAME_STATE_TYPE.MANAGE_MAIN, s_Manage_Main.new(self))
	add_state(StateEnum.GAME_STATE_TYPE.MANAGE_CHANGE, s_Manage_Change.new(self))
	add_state(StateEnum.GAME_STATE_TYPE.MANAGE_CHANGE_RING, s_Manage_Change_Ring.new(self))
