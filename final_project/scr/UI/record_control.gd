extends VBoxContainer

signal first_data

@onready var game_label: Label = $game/switch_game/game/Label
@onready var round_label: Label = $round/switch_round/round/Label

@onready var db = SQLite.new()

var record_data
var game_max = 1
var round_max: Array = [1]
@onready var game_page = 1
@onready var round_page = 1

func _ready():
	_refresh_data()
	_game_count_max()
	_round_count_max()
	
func _refresh_data():
	var db_dir = "user://data"
	var db_path = db_dir + "/game.db"
	record_data = db.select_rows("record", "game_id > 0", ["*"])
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
	
func _game_count_max():
	_refresh_data()
	for game in record_data:
		if int(game["game_id"]) > game_max:
			game_max = game["game_id"]

func _round_count_max():
	_refresh_data()
	round_max = [1]
	for game in range(1, game_max+1):
		var sql = "SELECT * FROM record WHERE game_id = ?"
		db.query_with_bindings(sql, [str(game)])
		var rounds_in_game = db.query_result
		var max_var = 0
		for round_i in rounds_in_game:
			if int(round_i["round_id"]) > max_var:
				max_var = int(round_i["round_id"])
		round_max.append(max_var)
	print(round_max)
	
	
func _page_change(type, n):
	record_data = db.select_rows("record", "game_id > 0", ["*"])
	var reset_round = false
	var type_max
	if type == "game":
		type = game_page
		type_max = game_max
		reset_round = true
	else:
		type = round_page
		type_max = round_max[game_page]
		
	if type + n > 0 and type + n <= type_max:
		type += n
		if reset_round:
			game_page = type
			game_label.text = "遊戲局數：" + str(game_page)
			round_page = 1
			
		else:
			round_page = type
		round_label.text = "回合數：" + str(round_page)
	else:
		print("OVER")
