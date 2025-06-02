extends VBoxContainer

@onready var actor_test = $actor_test
@onready var actor_page = 0
@onready var all_actor_data = actor_test.db.select_rows("actor", "id > 0", ["*"])
@onready var search_actor_data = actor_test.db.select_rows("actor", "id > 0", ["*"])
var object_delete = load("res://scr/UI/object_delete.gd").new()

signal show_alert(msg:String)

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
		
func refresh():
	all_actor_data = actor_test.db.select_rows("actor", "id > 0", ["*"])
	search_actor_data = all_actor_data
	actor_page = 0# 可選，刷新時回到第一頁
	_page_update()
		
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
	new_actor.get_node("HBC/actor_delete/actor_delete_btn").pressed.connect(Callable(self, "_on_actor_delete_pressed").bind(str(search_actor_data[actor_n]["id"])))

func _on_actor_delete_pressed(actor_id):
	# 查詢該 actor 的 level
	var actor_data = actor_test.db.select_rows("actor", "id = " + str(actor_id), ["level"])
	if actor_data.size() == 0:
		return
	var level = actor_data[0]["level"]
	# 查詢該 level 有幾筆資料
	var level_count = actor_test.db.select_rows("actor", "level = " + str(level), ["id"])
	if level_count.size() <= 3:
		# 呼叫 ui_manage_change_actor 的 show_alert
		show_alert.emit("❌ 不可把一個等級的角色刪除至低於3個")
		return
	# 正常刪除
	print("deleted")
	object_delete._object_delete(actor_test.db, "actor", str(actor_id))
	search_actor_data = object_delete._refresh_database(actor_test.db, "actor")
	_page_update()

func _refresh_database():
	print("refreshed")
	search_actor_data = object_delete._refresh_database(actor_test.db, "actor")
	_page_update()
