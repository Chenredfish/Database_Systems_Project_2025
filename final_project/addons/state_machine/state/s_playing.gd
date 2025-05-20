extends BaseState
class_name s_Playing

var to_manage_main:bool = false
var to_show_ring:bool = false


func enter(_msg:Dictionary = {}):
	print("into state of s_Playing")
	
	if !state_machine.has_value('level'):
		state_machine.set_value('level', 1)
	
	if !state_machine.has_value('enemy'):
		create_level_enemy(state_machine.get_value('level'))
		
	agent.add_child(state_machine.get_value('actor'))
	
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

func create_level_enemy(level:int):
	var enemy_data:Array = agent.db.select_rows("actor", "level = " + str(level), ["*"])
	var rand_enemy_id:int = (randi() % enemy_data.size())
	state_machine.set_value('enemy', Actor.new(enemy_data[rand_enemy_id]))
