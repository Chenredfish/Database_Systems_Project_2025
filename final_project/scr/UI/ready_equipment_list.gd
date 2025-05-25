extends MarginContainer

@onready var equipment_1 = $VBoxContainer/equipment1
@onready var v_box_container = $VBoxContainer
@onready var equipment_page = 0

@export var max_amount_in_one_page:int = 5

var UI_normal_theme = load("res://assets/UI_Theme.tres")
var UI_chosen_theme = load("res://assets/UI_chosen_theme.tres")
var search_equipment_data:Array[Equipment] = []
var all_equipment_data:Array[Equipment] = []
<<<<<<< HEAD
=======
var equipment_chosen
>>>>>>> e5afa4e2638a0a7ea518931f931ac0dc2cca78aa

func _ready() -> void:
	equipment_1.hide()

func input_show_equipment_data(actor:Actor):
	search_equipment_data = actor.get("equipment_list")
	all_equipment_data = search_equipment_data
	_page_update()
	
func _page_change(x):	#換頁
	if equipment_page + x >= 0 and search_equipment_data.size() > (equipment_page + x) * max_amount_in_one_page:
		equipment_page += x
		_page_update()
	else:
		print("OVER")
	
func _page_update():	#刷新頁面
	for child in v_box_container.get_children():
		if child.name.begins_with("new_equipment"):
			child.queue_free()
	var count = equipment_page * max_amount_in_one_page
	while count < equipment_page * max_amount_in_one_page + max_amount_in_one_page and count < search_equipment_data.size():
		_add_equipment(count)
		count += 1
<<<<<<< HEAD
		
func _search_equipment(keyword:String):
	var count = 0
	var check = true
	if keyword == "":
		check = false
	search_equipment_data = []
	for child in v_box_container.get_children():
		if child.name.begins_with("new_equipment"):
			child.queue_free()
	while count < all_equipment_data.size() and check:
		if keyword in all_equipment_data[count].get("name"):
			search_equipment_data.append(all_equipment_data[count])
		count += 1
	if check != true:
		search_equipment_data = all_equipment_data
	await get_tree().process_frame
	#print(search_ring_data)
	_page_update()
=======
	print("refreshed")
>>>>>>> e5afa4e2638a0a7ea518931f931ac0dc2cca78aa

func _add_equipment(equipment_n):
	var new_equipment = equipment_1.duplicate()
	new_equipment.name = "new_equipment" + str(equipment_n)
	var equipment_choose_btn = new_equipment.get_node("HBoxContainer/equipment_choose/equipment_choose_btn")
	v_box_container.add_child(new_equipment)
	new_equipment.show()
	new_equipment.get_node("HBoxContainer/equipment_id/Label").text = str(search_equipment_data[equipment_n].get("id"))
	new_equipment.get_node("HBoxContainer/equipment_name/Label").text = str(search_equipment_data[equipment_n].get("name"))
	new_equipment.get_node("HBoxContainer/equipment_level/Label").text = str(search_equipment_data[equipment_n].get("level"))
	new_equipment.get_node("HBoxContainer/equipment_attack_defence/Label").text = str(search_equipment_data[equipment_n].get("attack_defence"))
	new_equipment.get_node("HBoxContainer/equipment_magic_defence/Label").text = str(search_equipment_data[equipment_n].get("magic_defence"))
	equipment_choose_btn.pressed.connect(Callable(self, "_equipment_choose").bind(equipment_n, new_equipment))

func _equipment_choose(equipment_num, equipment):
	for child in v_box_container.get_children():
		if child.name != "new_equipment" + str(equipment_num):
			child.theme = UI_normal_theme
		else:
			child.theme = UI_chosen_theme
			equipment_chosen = equipment
