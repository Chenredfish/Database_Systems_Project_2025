extends MarginContainer

@onready var ring_choices: VBoxContainer = $rings/ring_choices
@onready var ring_test: HBoxContainer = $rings/ring_choices/ring_test
@onready var ring_chosen = $rings/ring_chosen/VBC
@onready var db = SQLite.new()
var all_ring_data

func _ready():
	db.path = "res://data/game.db"
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
		target_ring = db.query_result[0]
		new_ring_choice.get_node("ring_name/Label").text = target_ring["name"]
	
	db.query_with_bindings(sql, [round_data["player_ring_id"]])
	target_ring = db.query_result[0]
	ring_chosen.get_node("ring_name").text = str(target_ring["name"])
	ring_chosen.get_node("ring_level").text = "等級：" + str(target_ring["level"])
	ring_chosen.get_node("ring_health").text = "生命值：" + str(target_ring["health"])
	ring_chosen.get_node("ring_attack_power").text = "物理攻擊：" + str(target_ring["attack_power"])
	ring_chosen.get_node("ring_magic_power").text = "魔法攻擊：" + str(target_ring["magic_power"])
	ring_chosen.get_node("ring_attack_defence").text = "物理防禦：" + str(target_ring["attack_defence"])
	ring_chosen.get_node("ring_magic_defence").text = "魔法防禦：" + str(target_ring["magic_defence"])
