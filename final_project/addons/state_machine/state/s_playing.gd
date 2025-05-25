extends BaseState
class_name s_Playing

var to_manage_main:bool = false
var to_show_ring:bool = false
var to_ready_state:bool = false

var db = SQLite.new()


func enter(_msg:Dictionary = {}):
	print("into state of s_Playing")
	
	db.path = "res://data/game"
	db.open_db()
	
	if !state_machine.has_value('level'):
		state_machine.set_value('level', 1)
	
	if !state_machine.has_value('is_pause'):
		state_machine.set_value('is_pause', false)
	
	create_actor_node()
	
	agent.ui_layer.show_ui_playing()
	if !agent.ui_layer.exit_playing.is_connected(exit_playing):
		agent.ui_layer.exit_playing.connect(exit_playing)
	if !agent.ui_layer.to_show_ring.is_connected(show_ring):
		agent.ui_layer.to_show_ring.connect(show_ring)
	if !agent.ui_layer.to_pause.is_connected(pause_button_pressed):
		agent.ui_layer.to_pause.connect(pause_button_pressed)
		
	update_ui_actor_health('player')
	update_ui_actor_health('enemy')

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
		
	#切換ready
	if state_machine.has_value('to_ready_state'):
		to_ready_state = state_machine.get_value('to_ready_state')
	if to_ready_state:
		transform_to(StateEnum.GAME_STATE_TYPE.READY)
	
	#計算攻擊
	if !state_machine.get_value('is_pause'):
		update_actor_cooldown(delta)
	
func exit():
	agent.ui_layer.hide_ui_playing()
	
	to_manage_main = false
	state_machine.set_value('to_manage_main', to_manage_main)
	
	to_show_ring = false
	state_machine.set_value('to_show_ring', to_show_ring)
	
	#處理目前等級
	if !state_machine.get_value('is_pause'):
		update_level()
	
func update_level():
	var level = state_machine.get_value('level')
	var count_next_level = 0
	
	if state_machine.has_value('count_next_level'):
		count_next_level = state_machine.get_value('count_next_level')
	
	count_next_level += 1
	
	if count_next_level >= 5: #打超過五次就 level up !
		level += 1
		count_next_level = 0  # 重置進度

	state_machine.set_value('level', level)
	state_machine.set_value('count_next_level', count_next_level)

func exit_playing():
	state_machine.set_value('to_manage_main', true)
	pause_battle()

func show_ring(aim:String):
	state_machine.set_value('to_show_ring', true)
	state_machine.set_value('to_show_aim', aim)
	pause_battle()
	
func create_actor_node():
	if !state_machine.has_value('enemy'):
		create_level_actor(state_machine.get_value('level'), 'enemy')
		
	if !state_machine.has_value('player'):
		create_level_actor(0, 'player')
	
	if !agent.has_node("player"):
		agent.add_child(state_machine.get_value('player'))
	else:
		agent.get_node("player").show()
		
	if !agent.has_node("enemy"):
		agent.add_child(state_machine.get_value('enemy'))
	else:
		agent.get_node("enemy").show()

func create_level_actor(level:int, name:String):
	var actor_data:Array = db.select_rows("actor", "level = " + str(level), ["*"])
	var rand_actor_id:int = (randi() % actor_data.size())
	var actor = Actor.new(actor_data[rand_actor_id])
	actor.name = name
	
	state_machine.set_value(name, actor)
	
func pause_battle():
	agent.get_node("player").hide()
	agent.get_node("enemy").hide()
	state_machine.set_value('is_pause', true)
	#一律以暫停圖片回到戰鬥
	agent.ui_layer.set_pause_btn_to_pause()
	
func pause_button_pressed():
	var is_pause:bool = state_machine.get_value('is_pause')
	state_machine.set_value('is_pause', !is_pause)
	
func update_actor_cooldown(delta: float) -> void:
	var player: Actor = state_machine.get_value("player")
	var enemy: Actor = state_machine.get_value("enemy")

	if player and player.health > 0:
		player.attack_timer += delta
		if player.attack_timer >= player.cooldown:
			var result = player.damage_calculate(enemy,true,true)
			#print(result)
			player.attack_timer = 0.0
			update_ui_actor_health('enemy')
	else:
		print("game over")
		pause_battle()
	
	if enemy and enemy.health > 0:
		enemy.attack_timer += delta
		if enemy.attack_timer >= enemy.cooldown:
			var result = enemy.damage_calculate(player,true,false)
			
			#print(result)
			enemy.attack_timer = 0.0
			update_ui_actor_health('player')
	else:
		state_machine.set_value('to_ready_state', true)
		
func update_ui_actor_health(aim:String):
	var max_value = state_machine.get_value(aim)._get_max_health()
	var value = state_machine.get_value(aim).get('health') 
	#print("max_value = " + str(max_value))
	agent.ui_layer.ui_playing_change_health_bar(aim, max_value, value)
