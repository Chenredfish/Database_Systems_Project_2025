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
	
	is_a_new_game()
	print("目前是第" + str(state_machine.get_value('game_id')) + "把遊戲的第" + str(state_machine.get_value('round_id')) + "輪")
	
	create_actor_node()
	_display_actor_elements()
	
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
	agent.ui_layer.to_show_ring.disconnect(show_ring)
	
	to_ready_state = false
	state_machine.set_value('to_ready_state', to_ready_state)
	
	#處理目前等級
	if !state_machine.get_value('is_pause'):
		update_level()
	
func update_level():
	var level = state_machine.get_value('level')
	var count_next_level = 0
	
	if state_machine.has_value('count_next_level'):
		count_next_level = state_machine.get_value('count_next_level')
	
	count_next_level += 1
	
	if count_next_level >= 3: #打超過3次就 level up !
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
	state_machine.set_value('from_playing', true)
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
			var result = player.damage_calculate(enemy,player.get('skill').get('is_magic'), true)
			#print(result)
			player.attack_timer = 0.0
			update_ui_actor_health('enemy')
	else:
		print("game over")
		pause_battle()
	
	if enemy and enemy.health > 0:
		enemy.attack_timer += delta
		if enemy.attack_timer >= enemy.cooldown:
			var result = enemy.damage_calculate(player,enemy.get('skill').get('is_magic'),false)
			
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
	
const ELEMENT_ICONS = {
	"火": "res://assets/elements_icon/1.png", 
	"水": "res://assets/elements_icon/2.png", 
	"草": "res://assets/elements_icon/3.png", 
	"光": "res://assets/elements_icon/4.png", 
	"暗": "res://assets/elements_icon/5.png", 
}

func _display_actor_elements():
	var player_element_texture_rect = agent.ui_layer.ui_playing.get_node("MarginContainer/HBoxContainer/character/VBoxContainer/HBoxContainer/armor/TextureRect")
	var enemy_element_texture_rect = agent.ui_layer.ui_playing.get_node("MarginContainer/HBoxContainer/enemy/VBoxContainer/HBoxContainer/armor/TextureRect")

	# 元素
	var player_actor = state_machine.get_value('player')
	if player_element_texture_rect and player_actor:
		var player_element = player_actor.get('element')
		if ELEMENT_ICONS.has(player_element):
			var icon_path = ELEMENT_ICONS[player_element]
			var element_texture = load(icon_path)
			if element_texture:
				player_element_texture_rect.texture = element_texture
				print("玩家屬性icon: " + player_element)
			else:
				push_warning("無法載入玩家屬性icon: " + icon_path)
		else:
			push_warning("未知玩家屬性: " + str(player_element) + " 或未設定對應icon。")
	else:
		push_warning("無法找到 UI Playing 中的玩家元素顯示節點或玩家Actor不存在。")
		
	# 顯示敵人元素
	var enemy_actor = state_machine.get_value('enemy')
	if enemy_element_texture_rect and enemy_actor:
		var enemy_element = enemy_actor.get('element')
		if ELEMENT_ICONS.has(enemy_element):
			var icon_path = ELEMENT_ICONS[enemy_element]
			var element_texture = load(icon_path)
			if element_texture:
				enemy_element_texture_rect.texture = element_texture
				print("敵人屬性icon: " + enemy_element)
			else:
				push_warning("無法載入敵人屬性icon: " + icon_path)
		else:
			push_warning("未知敵人屬性: " + str(enemy_element) + " 或未設定對應圖示。")
	else:
		push_warning("無法找到 UI Playing 中的敵人元素顯示節點或敵人Actor不存在。")

func is_a_new_game():
	if !state_machine.has_value('game_id'):
		var sql = "SELECT MAX(game_id) as max_game_id FROM record"
		db.query(sql)
		state_machine.set_value('game_id', db.query_result[0]["max_game_id"] + 1)
	
	if !state_machine.has_value('round_id'):
		state_machine.set_value('round_id', 1)
