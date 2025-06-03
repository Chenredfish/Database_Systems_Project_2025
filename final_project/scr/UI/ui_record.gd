extends Control

signal exit_btn_pressed

@onready var vbc: VBoxContainer = $MC/VBC
@onready var ring_ui: MarginContainer = $MC/VBC/HBC/ring_and_skill/ring
@onready var skill: MarginContainer = $MC/VBC/HBC/ring_and_skill/skill
@onready var player_and_enemy: PanelContainer = $MC/VBC/HBC/player_and_enemy
@onready var db = SQLite.new()

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
	_all_data_update()

func _on_exit_button_pressed():
	exit_btn_pressed.emit()

func _on_game_previous_page_btn_pressed() -> void:
	vbc._page_change("game", -1)
	_all_data_update()

func _on_game_next_page_btn_pressed() -> void:
	if vbc.game_page == vbc.game_max:
		vbc._game_count_max()
		vbc._round_count_max()
	vbc._page_change("game", 1)
	_all_data_update()

func _on_round_previous_page_btn_pressed() -> void:
	vbc._page_change("round", -1)
	_all_data_update()

func _on_round_next_page_btn_pressed() -> void:
	if vbc.game_page == vbc.game_max:
		vbc._round_count_max()
	vbc._page_change("round", 1)
	_all_data_update()

func _all_data_update():
	var sql = "SELECT * FROM record WHERE game_id = ? and round_id = ?"
	var round_data
	db.query_with_bindings(sql, [str(vbc.game_page), str(vbc.round_page)])
	if db.query_result:
		round_data = db.query_result[0]
	else:
		round_data = null
		return 
	ring_ui._ring_page_update(round_data)
	skill._skill_page_update(round_data)
	player_and_enemy._actor_page_update(round_data)
