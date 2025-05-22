extends BaseState
class_name s_Ready

var db := SQLite.new()

var available_skills = []
var available_rings = []
var available_equipment = null

func enter(_msg: Dictionary = {}):
	print("into state of s_Ready")
	
	db.path = "res://data/game"
	db.open_db()

	var level = state_machine.get_value("level")
	var player = state_machine.get_value("player")
	
	update_level()
	
	free_old_enemy()
	create_level_enemy(level)


	available_skills = fetch_random_skills(level)
	available_rings = fetch_random_rings(level)
	available_equipment = fetch_random_equipment(level)

	#存變數到狀態機
	state_machine.set_value("available_skills", available_skills)
	state_machine.set_value("available_rings", available_rings)
	state_machine.set_value("available_equipment", available_equipment)

func update(delta):
	pass

func exit():
	pass

#從enter裡拉出選skill、ring、equip
func fetch_random_skills(level: int) -> Array:
	var min_level = max(1, level - 2)
	db.query("SELECT * FROM skill WHERE level BETWEEN %d AND %d" % [min_level, level])
	var results = db.query_result.duplicate()
	results.shuffle()
	return results.slice(0, 3)

func fetch_random_rings(level: int) -> Array:
	var min_level = max(1, level - 2)
	db.query("SELECT * FROM ring WHERE level BETWEEN %d AND %d" % [min_level, level])
	var results = db.query_result.duplicate()
	results.shuffle()
	return results.slice(0, 3)

func fetch_random_equipment(level: int) -> Dictionary:
	var min_level = max(1, level - 2)
	db.query("SELECT * FROM equipment WHERE level BETWEEN %d AND %d" % [min_level, level])
	var results = db.query_result.duplicate()
	results.shuffle()
	return results[0] if results.size() > 0 else null

func free_old_enemy():
	for child in agent.get_children():
		if child.name == "enemy":
			child.queue_free()
		
func create_level_enemy(level:int):
	var enemy_data = db.select_rows("actor", "level = " + str(level), ["*"])
	if enemy_data.size() > 0:
		var rand_enemy_id:int = randi() % enemy_data.size()
		state_machine.set_value('enemy', Actor.new(enemy_data[rand_enemy_id]))
	else:
		print("enemy_data 是空的，無法選擇隨機敵人")

#更新目前的level, 打五次同個level就來
func update_level():
	pass
