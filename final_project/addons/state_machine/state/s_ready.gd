extends BaseState
class_name s_Ready

var db := SQLite.new()

var available_skills = []
var available_rings = []
var available_equipment = null

func enter(_msg: Dictionary = {}):
	print("into state of s_Ready")

	var level = state_machine.get_value("level")
	var actor = state_machine.get_value("actor")

	if not db.open("res://data/game.db"):
		push_error("無法開啟資料庫")
		return

	var min_level = max(1, level - 2)  # level~level-2，不低於 1

	# 抓技能
	db.query("SELECT * FROM skill WHERE level BETWEEN %d AND %d" % [min_level, level])
	var skill_results = db.query_result.duplicate()
	skill_results.shuffle()
	available_skills = skill_results.slice(0, 3)

	# 抓ring
	db.query("SELECT * FROM ring WHERE level BETWEEN %d AND %d" % [min_level, level])
	var ring_results = db.query_result.duplicate()
	ring_results.shuffle()
	available_rings = ring_results.slice(0, 3)

	# 抓裝備
	db.query("SELECT * FROM equipment WHERE level BETWEEN %d AND %d" % [min_level, level])
	var equip_results = db.query_result.duplicate()
	equip_results.shuffle()
	available_equipment = equip_results[0] if equip_results.size() > 0 else null

	# 存進狀態機變數給 UI 或其他狀態用
	state_machine.set_value("available_skills", available_skills)
	state_machine.set_value("available_rings", available_rings)
	state_machine.set_value("available_equipment", available_equipment)

	# UI顯示隨機生成的東西
	#agent.ui_layer.show_技能_selection(available_skills)
	#agent.ui_layer.show_戒指_selection(available_rings)
	#if actor:
		#agent.ui_layer.show_actor_裝備(actor.get_all_equipment())



func update(delta):
	pass

func exit():
	pass
