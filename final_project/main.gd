extends Node2D

#狀態機
@onready var game_state_machine = $GameStateMachine
#UI
@onready var ui_layer = $UILayer

func _ready():
	
	ui_layer.show()
	game_state_machine.launch()
	
