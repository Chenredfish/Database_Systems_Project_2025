extends PanelContainer

@onready var player_and_enemy: VBoxContainer = $player_and_enemy
@onready var db = SQLite.new()
var all_equipment_data
var all_actor_data

func _ready():
	db.path = "res://data/game.db"
	db.open_db()
	all_equipment_data = db.select_rows("equipment", "id > 0", ["*"])
	all_actor_data = db.select_rows("actor", "id > 0", ["*"])

func _actor_page_update(round_data):
	var sql = "SELECT * FROM skill WHERE id = ?"
	var target_skill
	player_and_enemy.get_node("enemy_skill_id").text = "敵人技能代號：" + str(round_data["enemy_skill_id"])
	db.query_with_bindings(sql, [round_data["enemy_skill_id"]])
	target_skill = db.query_result[0]
	player_and_enemy.get_node("enemy_skill_name").text = "敵人技能名稱：" + target_skill["name"]
	
	sql = "SELECT * FROM actor WHERE id = ?"
	var target_enemy
	db.query_with_bindings(sql, [round_data["enemy_id"]])
	target_enemy = db.query_result[0]
	player_and_enemy.get_node("enemy_id").text = "敵人代號：" + str(target_enemy["id"])
	player_and_enemy.get_node("enemy_name").text = "敵人名稱：" + target_enemy["name"]
	
	sql = "SELECT * FROM equipment WHERE id = ?"
	var target_equipment
	db.query_with_bindings(sql, [round_data["player_equiment_id"]])
	target_equipment = db.query_result[0]
	player_and_enemy.get_node("player_equipment_id").text = "裝備代號：" + str(target_equipment["id"])
	player_and_enemy.get_node("player_equipment_name").text = "裝備名稱：" + target_equipment["name"]
