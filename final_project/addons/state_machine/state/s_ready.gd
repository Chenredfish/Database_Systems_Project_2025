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

	# 抓技能
	db.query("SELECT * FROM skill WHERE level <= %d" % level)
	var skill_results = db.query_result.duplicate()
	skill_results.shuffle()
	available_skills = skill_results.slice(0, 3)

	# 抓戒指
	db.query("SELECT * FROM ring WHERE level <= %d" % level)
	var ring_results = db.query_result.duplicate()
	ring_results.shuffle()
	available_rings = ring_results.slice(0, 3)

	# 抓裝備
	db.query("SELECT * FROM equipment WHERE level <= %d" % level)
	var equip_results = db.query_result.duplicate()
	equip_results.shuffle()
	available_equipment = equip_results[0] if equip_results.size() > 0 else null

	# 存進狀態機變數給 UI 或其他狀態用
	state_machine.set_value("available_skills", available_skills)
	state_machine.set_value("available_rings", available_rings)
	state_machine.set_value("available_equipment", available_equipment)

	# skill、ring、所有equipment顯示
	agent.ui_layer.show_skill_selection(available_skills)
	agent.ui_layer.show_ring_selection(available_rings)
	if actor:
		agent.ui_layer.show_actor_equipment(actor.get_all_equipment())

func update(delta):
	pass

func exit():
	pass
