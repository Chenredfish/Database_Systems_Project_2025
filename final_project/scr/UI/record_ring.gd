extends MarginContainer

@onready var ring_choices: VBoxContainer = $rings/ring_choices
@onready var ring_test: HBoxContainer = $rings/ring_choices/ring_test
@onready var ring_chosen: PanelContainer = $rings/ring_chosen
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
	
	for new_ring in range(1,4):
		var new_ring_choice = ring_test.duplicate()
		new_ring_choice.name = "new_ring_choice" + str(new_ring)
		ring_choices.add_child(new_ring_choice)
		new_ring_choice.show()
		new_ring_choice.get_node("ring_id/Label").text = str(round_data["ring_choice_id_" + str(new_ring)])
		var sql = "SELECT * FROM ring WHERE id = ?"
		db.query_with_bindings(sql, [round_data["ring_choice_id_" + str(new_ring)]])
		var target_ring = db.query_result[0]
		new_ring_choice.get_node("ring_name/Label").text = target_ring["name"]
