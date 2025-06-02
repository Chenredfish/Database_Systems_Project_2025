extends Control

signal exit_btn_pressed

@onready var vbc: VBoxContainer = $MC/VBC
@onready var ring_ui: MarginContainer = $MC/VBC/HBC/ring_and_skill/ring
@onready var skill: MarginContainer = $MC/VBC/HBC/ring_and_skill/skill
@onready var player_and_enemy: PanelContainer = $MC/VBC/HBC/player_and_enemy
@onready var db = SQLite.new()

func _ready() -> void:
	db.path = "res://data/game.db"
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
	db.query_with_bindings(sql, [str(vbc.game_page), str(vbc.round_page)])
	var round_data = db.query_result[0] 
	ring_ui._ring_page_update(round_data)
	skill._skill_page_update(round_data)
	player_and_enemy._actor_page_update(round_data)
