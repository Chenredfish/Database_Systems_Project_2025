extends MarginContainer

@onready var equipment_1 = $VBoxContainer/equipment1
@onready var v_box_container = $VBoxContainer
@onready var equipment_page = 0

@export var max_amount_in_one_page:int = 5

var UI_normal_theme = load("res://assets/UI_Theme.tres")
var UI_chosen_theme = load("res://assets/UI_chosen_theme.tres")
var search_equipment_data:Array[Equipment] = []
var all_equipment_data:Array[Equipment] = []
var equipment_choosen_num:int = -1

var equipment_chosen:Node

signal equipment_choose(equipments_index:int)


func _ready() -> void:
	equipment_1.hide()

func input_show_equipment_data(equipments:Array):
	search_equipment_data = equipments
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
		if child.name != "equipment1":
			child.queue_free()
	await get_tree().process_frame
	var count = equipment_page * max_amount_in_one_page
	while count < (equipment_page + 1) * max_amount_in_one_page and count < search_equipment_data.size():
		_add_equipment(count)
		count += 1
		
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

	print("refreshed")


func _add_equipment(equipment_n:int):
	var new_equipment = equipment_1.duplicate()
	new_equipment.name = "new_equipment" + str(equipment_n)
	var equipment_choose_btn = new_equipment.get_node("HBoxContainer/equipment_choose/equipment_choose_btn")
	if equipment_n == equipment_choosen_num:
		new_equipment.theme = UI_chosen_theme
	v_box_container.add_child(new_equipment)
	new_equipment.show()
	new_equipment.get_node("HBoxContainer/equipment_id/Label").text = str(search_equipment_data[equipment_n].get("id"))
	new_equipment.get_node("HBoxContainer/equipment_name/Label").text = str(search_equipment_data[equipment_n].get("name"))
	new_equipment.get_node("HBoxContainer/equipment_level/Label").text = str(search_equipment_data[equipment_n].get("level"))
	new_equipment.get_node("HBoxContainer/equipment_attack_defence/Label").text = str(search_equipment_data[equipment_n].get("attack_defence"))
	new_equipment.get_node("HBoxContainer/equipment_magic_defence/Label").text = str(search_equipment_data[equipment_n].get("magic_defence"))
	equipment_choose_btn.pressed.connect(Callable(self, "_equipment_choose").bind(equipment_n, new_equipment))

func _equipment_choose(equipment_n:int, equipment:Node):
	equipment_choosen_num = equipment_n
	for child in v_box_container.get_children():
		if child.name != "new_equipment" + str(equipment_choosen_num):
			child.theme = UI_normal_theme
		else:
			child.theme = UI_chosen_theme
			equipment_chosen = equipment
			equipment_choose.emit(equipment_choosen_num)
