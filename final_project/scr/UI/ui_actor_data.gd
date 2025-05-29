extends PanelContainer

@onready var actor_name = $MarginContainer/GridContainer/name
@onready var health = $MarginContainer/GridContainer/health
@onready var max_health = $MarginContainer/GridContainer/max_health
@onready var level = $MarginContainer/GridContainer/level
@onready var type = $MarginContainer/GridContainer/type
@onready var attack_power = $MarginContainer/GridContainer/attack_power
@onready var magic_power = $MarginContainer/GridContainer/magic_power
@onready var attack_defence = $MarginContainer/GridContainer/attack_defence
@onready var magic_defence = $MarginContainer/GridContainer/magic_defence


func show_actor_data(actor:Actor):
	actor_name.text = str(actor.get('_name'))
	health.text = str(actor.get("health"))
	max_health.text = str(int(actor.get('max_health')))
	level.text = str(actor.get("level"))
	
	#取名錯誤，type已經改名為element
	type.text = str(actor.get("element"))
	#這裡有取名錯誤
	attack_power.text = str(actor.get("attack_point"))
	magic_power.text = str(actor.get("magic_point"))
	
	attack_defence.text = str(actor.get("attack_defence"))
	magic_defence.text = str(actor.get("magic_defence"))
	
	var ring_state = actor.get_combined_ring_state()
	attack_power.text += " × " + str(1 + ring_state["attack_power"])
	magic_power.text += " × " + str(1 + ring_state["magic_power"])
	attack_defence.text += " × " + str(1 + ring_state["attack_defence"])
	magic_defence.text += " × " + str(1 + ring_state["magic_defence"])
	max_health.text += " × " + str(1 + ring_state["health"])
