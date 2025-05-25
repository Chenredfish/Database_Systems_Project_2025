extends MarginContainer

@onready var equipment_1 = $VBoxContainer/equipment1
@onready var v_box_container = $VBoxContainer
@onready var equipment_page = 0

var search_equipment_data:Array[Equipment] = []
var all_ring_data:Array[Equipment] = []

func _ready() -> void:
	equipment_1.hide()

func input_show_equipment_data(actor:Actor):
	search_equipment_data = actor.get("equipment_list")
	all_ring_data = search_equipment_data
	_page_update()
	
func _page_update():	#刷新頁面
	for child in self.get_children():
		if child.name.begins_with("new_ring"):
			child.queue_free()
	var count = equipment_page * 6
	while count < equipment_page * 6 + 6 and count < search_equipment_data.size():
		_add_ring(count)
		count += 1

func _add_ring(equipment_n):
	var new_equipment = equipment_1.duplicate()
	new_equipment.name = "new_equipment" + str(equipment_n)
	v_box_container.add_child(new_equipment)
	new_equipment.show()
	new_equipment.get_node("HBoxContainer/equipment_id/Label").text = str(search_equipment_data[equipment_n].get("id"))
	new_equipment.get_node("HBoxContainer/equipment_name/Label").text = str(search_equipment_data[equipment_n].get("name"))
	new_equipment.get_node("HBoxContainer/equipment_level/Label").text = str(search_equipment_data[equipment_n].get("level"))
	print(str(search_equipment_data[equipment_n].get("level")))
	new_equipment.get_node("HBoxContainer/equipment_attack_defence/Label").text = str(search_equipment_data[equipment_n].get("attack_defence"))
	new_equipment.get_node("HBoxContainer/equipment_magic_defence/Label").text = str(search_equipment_data[equipment_n].get("magic_defence"))
