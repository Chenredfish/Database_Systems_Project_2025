extends MarginContainer

@onready var ring_choices: VBoxContainer = $rings/ring_choices
@onready var ring_test: HBoxContainer = $rings/ring_choices/ring_test
@onready var ring_chosen = $rings/ring_chosen/VBC
@onready var db = SQLite.new()
var all_ring_data
var check_deleted = {"id": "已刪除",
 "name": "已刪除",
 "level": "已刪除", 
"health": "已刪除", 
"attack_power": "已刪除",
"magic_power": "已刪除",
"attack_defence": "已刪除",
"magic_defence": "已刪除"}

func _ready():
	var db_dir = "user://data"
	var db_path = db_dir + "/game.db"
	# 確保 user://data 資料夾存在
	if not DirAccess.dir_exists_absolute(db_dir):
		DirAccess.make_dir_recursive_absolute(db_dir)
	# 如果 user://data/game.db 不存在，從 res://data/game.db 複製過去
	if not FileAccess.file_exists(db_path):
		var src = FileAccess.open("res://data/game.db", FileAccess.READ)
		var dst = FileAccess.open(db_path, FileAccess.WRITE)
		dst.store_buffer(src.get_buffer(src.get_length()))
		src.close()
		dst.close()
	db.path = db_path
	db.open_db()
	all_ring_data = db.select_rows("ring", "id > 0", ["*"])
	ring_test.hide()

func _ring_page_update(round_data):
	for child in ring_choices.get_children():
		if child.name != "ring_test" and child.name != "ring_id_name":
			child.queue_free()
	
	var sql = "SELECT * FROM ring WHERE id = ?"
	var target_ring
	for new_ring in range(1,4):
		var new_ring_choice = ring_test.duplicate()
		new_ring_choice.name = "new_ring_choice" + str(new_ring)
		ring_choices.add_child(new_ring_choice)
		new_ring_choice.show()
		new_ring_choice.get_node("ring_id/Label").text = str(round_data["ring_choice_id_" + str(new_ring)])
		db.query_with_bindings(sql, [round_data["ring_choice_id_" + str(new_ring)]])
		target_ring = _check_delete(db.query_result)
		new_ring_choice.get_node("ring_name/Label").text = target_ring["name"]
	
	db.query_with_bindings(sql, [round_data["player_ring_id"]])
	target_ring = _check_delete(db.query_result)
	_set_full_ring(target_ring)	

func _set_full_ring(target_ring):
	ring_chosen.get_node("ring_name").text = str(target_ring["name"])
	ring_chosen.get_node("ring_id").text = "狀態代號：" + str(target_ring["id"])
	ring_chosen.get_node("ring_level").text = "狀態等級：" + str(target_ring["level"])
	ring_chosen.get_node("ring_health").text = "生命值：" + str(target_ring["health"])
	ring_chosen.get_node("ring_attack_power").text = "物理攻擊：" + str(target_ring["attack_power"])
	ring_chosen.get_node("ring_magic_power").text = "魔法攻擊：" + str(target_ring["magic_power"])
	ring_chosen.get_node("ring_attack_defence").text = "物理防禦：" + str(target_ring["attack_defence"])
	ring_chosen.get_node("ring_magic_defence").text = "魔法防禦：" + str(target_ring["magic_defence"])

func _check_delete(target : Array):
	print(target)
	if target == []:
		return check_deleted
	else:
		return target[0]
