extends Node2D

#狀態機
@onready var game_state_machine = $GameStateMachine
#UI
@onready var ui_layer = $UILayer

@onready var db = SQLite.new()



func _ready():
	
	randomize()
	
	db.path = "res://data/game"
	db.open_db()
	
	var level_0_actor_id:Array = db.select_rows("actor", "level = 0", ["id"])
	var number_level_0_actor:int = level_0_actor_id.size()
	var rand_actor_id = randi()%number_level_0_actor + 1 #id不會是0，但是%出來會出現0
	var rand_actor_data = db.select_rows("actor", "id = " + str(rand_actor_id), ["*"])
	#print(rand_actor_data[0])
	
	ui_layer.show()
	game_state_machine.launch()
	
	game_state_machine.set_value('actor', Actor.new(rand_actor_data[0]))
