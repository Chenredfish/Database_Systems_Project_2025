extends PanelContainer

@onready var player_and_enemy: VBoxContainer = $player_and_enemy
@onready var db = SQLite.new()
var all_equipment_data
var all_actor_data
var check_deleted = {"id": "已刪除", "name": "已刪除"}

func _ready():
	db.path = "res://data/game.db"
	db.open_db()
	all_equipment_data = db.select_rows("equipment", "id > 0", ["*"])
	all_actor_data = db.select_rows("actor", "id > 0", ["*"])

func _actor_page_update(round_data):
	player_and_enemy.get_node("player_level").text = "玩家等級：" + str(round_data["player_level"])
	var sql = "SELECT * FROM skill WHERE id = ?"
	var target_skill
	db.query_with_bindings(sql, [round_data["enemy_skill_id"]])
	target_skill = _check_delete(db.query_result)
	_set_enemy_skill(target_skill)
	
	sql = "SELECT * FROM actor WHERE id = ?"
	var target_enemy
	db.query_with_bindings(sql, [round_data["enemy_id"]])
	target_enemy = _check_delete(db.query_result)
	_set_enemy_name(target_enemy)
	
	sql = "SELECT * FROM equipment WHERE id = ?"
	var target_equipment
	db.query_with_bindings(sql, [round_data["player_equipment_id"]])
	target_equipment = _check_delete(db.query_result)
	_set_player_equipment(target_equipment)

	db.query_with_bindings(sql, [round_data["enemy_equipment_id"]])
	target_equipment = _check_delete(db.query_result)
	_set_enemy_equipment(target_equipment)
	
	sql = "SELECT * FROM ring WHERE id = ?"
	var target_ring
	db.query_with_bindings(sql, [round_data["enemy_ring_id"]])
	target_ring = _check_delete(db.query_result)
	_set_enemy_ring(target_ring)
	
func _set_enemy_skill(target_skill):
	player_and_enemy.get_node("enemy_skill_id").text = "敵人技能代號：" + str(target_skill["id"])
	player_and_enemy.get_node("enemy_skill_name").text = "敵人技能名稱：" + target_skill["name"]
	
func _set_enemy_name(target_enemy):
	player_and_enemy.get_node("enemy_id").text = "敵人代號：" + str(target_enemy["id"])
	player_and_enemy.get_node("enemy_name").text = "敵人名稱：" + target_enemy["name"]
	
func _set_player_equipment(target_equipment):
	player_and_enemy.get_node("player_equipment_id").text = "裝備代號：" + str(target_equipment["id"])
	player_and_enemy.get_node("player_equipment_name").text = "裝備名稱：" + target_equipment["name"]
	
func _set_enemy_equipment(target_equipment):
	player_and_enemy.get_node("enemy_equipment_id").text = "敵人裝備代號：" + str(target_equipment["id"])
	player_and_enemy.get_node("enemy_equipment_name").text = "敵人裝備名稱：" + target_equipment["name"]
	
func _set_enemy_ring(target_ring):
	player_and_enemy.get_node("enemy_ring_id").text = "敵人狀態代號：" + str(target_ring["id"])
	player_and_enemy.get_node("enemy_ring_name").text = "敵人狀態名稱：" + target_ring["name"]

func _check_delete(target : Array):
	print(target)
	if target == []:
		return check_deleted
	else:
		return target[0]
