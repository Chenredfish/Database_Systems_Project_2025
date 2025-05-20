extends BaseState
class_name s_Ready

var db := SQLite.new()

var available_skills = []
var available_rings = []
var available_equipment = null

func enter(_msg: Dictionary = {}):
	print("into state of s_Ready")

	var level = state_machine.get_value("level")
	var player = state_machine.get_value("player")

	if not db.open("res://data/game.db"):
		push_error("無法開啟資料庫")
		return

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
