extends VBoxContainer

@onready var actor_test = $actor_test
@onready var actor_page = 0
@onready var all_actor_data = actor_test.db.select_rows("actor", "id > 0", ["*"])
@onready var search_actor_data = actor_test.db.select_rows("actor", "id > 0", ["*"])

func _ready():
	actor_test.hide()
	_page_update()

func _page_update():	#刷新頁面
	for child in self.get_children():
		if child.name != "actor_test":
			child.queue_free()
	var count = actor_page * 6
	while count < actor_page * 6 + 6 and count < search_actor_data.size():
		_add_ring(count)
		count += 1
		
func _search_ring(keyword):
	var count = 0
	var check = true
	if keyword == "":
		check = false
	search_actor_data = []
	for child in self.get_children():
		if child.name != "actor_test":
			child.queue_free()
	while count < all_actor_data.size() and check:
		if keyword in all_actor_data[count]["name"]:
			search_actor_data.append(all_actor_data[count])
		count += 1
	if check != true:
		search_actor_data = all_actor_data
	print(search_actor_data)
	_page_update()

func _page_change(x):	#換頁
	if actor_page + x >= 0 and search_actor_data.size() > (actor_page + x) * 6:
		actor_page += x
		print(actor_page)
		_page_update()
	else:
		print("OVER")

func _add_ring(actor_n):	#顯示每個狀態
	var new_actor = actor_test.duplicate()
	new_actor.name = "new_actor" + str(actor_n)
	add_child(new_actor)
	new_actor.show()
	new_actor.get_node("HBC/actor_id/Label").text = str(search_actor_data[actor_n]["id"])
	new_actor.get_node("HBC/actor_name/Label").text = str(search_actor_data[actor_n]["name"])
	new_actor.get_node("HBC/actor_level/Label").text = str(search_actor_data[actor_n]["level"])
	new_actor.get_node("HBC/actor_element/Label").text = str(search_actor_data[actor_n]["element"])
	new_actor.get_node("HBC/actor_health/Label").text = str(search_actor_data[actor_n]["health"])
	new_actor.get_node("HBC/actor_attack_point/Label").text = str(search_actor_data[actor_n]["attack_point"])
	new_actor.get_node("HBC/actor_magic_point/Label").text = str(search_actor_data[actor_n]["magic_point"])
	new_actor.get_node("HBC/actor_attack_defence/Label").text = str(search_actor_data[actor_n]["attack_defence"])
	new_actor.get_node("HBC/actor_magic_defence/Label").text = str(search_actor_data[actor_n]["magic_defence"])
	
