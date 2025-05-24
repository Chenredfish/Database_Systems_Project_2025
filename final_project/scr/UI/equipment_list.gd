extends VBoxContainer

@onready var equipment_test = $equipment_test
@onready var equipment_page = 0
@onready var all_equipment_data = equipment_test.db.select_rows("equipment", "id > 0", ["*"])
@onready var search_equipment_data = equipment_test.db.select_rows("equipment", "id > 0", ["*"])
var object_delete = load("res://scr/UI/object_delete.gd").new()

func _ready():
	equipment_test.hide()
	_page_update()

func _page_update():	#刷新頁面
	for child in self.get_children():
		if child.name != "equipment_test":
			child.queue_free()
	var count = equipment_page * 6
	while count < equipment_page * 6 + 6 and count < search_equipment_data.size():
		_add_ring(count)
		count += 1
		
func _search_equipment(keyword):
	var count = 0
	var check = true
	if keyword == "":
		check = false
	search_equipment_data = []
	for child in self.get_children():
		if child.name != "equipment_test":
			child.queue_free()
	while count < all_equipment_data.size() and check:
		if keyword in all_equipment_data[count]["name"]:
			search_equipment_data.append(all_equipment_data[count])
		count += 1
	if check != true:
		search_equipment_data = all_equipment_data
	print(search_equipment_data)
	_page_update()

func _page_change(x):	#換頁
	if equipment_page + x >= 0 and search_equipment_data.size() > (equipment_page + x) * 6:
		equipment_page += x
		print(equipment_page)
		_page_update()
	else:
		print("OVER")

func _add_ring(equipment_n):	#顯示每個狀態
	var new_equipment = equipment_test.duplicate()
	new_equipment.name = "new_equipment" + str(equipment_n)
	add_child(new_equipment)
	new_equipment.show()
	new_equipment.get_node("HBC/equipment_id/Label").text = str(search_equipment_data[equipment_n]["id"])
	new_equipment.get_node("HBC/equipment_name/Label").text = str(search_equipment_data[equipment_n]["name"])
	new_equipment.get_node("HBC/equipment_level/Label").text = str(search_equipment_data[equipment_n]["level"])
	new_equipment.get_node("HBC/equipment_attack_defence/Label").text = str(search_equipment_data[equipment_n]["attack_defence"])
	new_equipment.get_node("HBC/equipment_magic_defence/Label").text = str(search_equipment_data[equipment_n]["magic_defence"])
	new_equipment.get_node("HBC/equipment_delete/equipment_delete_btn").pressed.connect(Callable(self, "_on_equipment_delete_pressed").bind(str(search_equipment_data[equipment_n]["id"])))

func _on_equipment_delete_pressed(equipment_id):
	print("deleted")
	object_delete._object_delete(equipment_test.db, "equipment", str(equipment_id))
	search_equipment_data = object_delete._refresh_database(equipment_test.db, "equipment")
	_page_update()

func _refresh_db():
	print("refreshed")
	search_equipment_data = equipment_test.db.select_rows("equipment", "id > 0", ["*"])
	_page_update()
