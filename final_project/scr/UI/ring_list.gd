extends GridContainer

signal next_page_pressed
signal previous_page_pressed
signal show_alert(msg:String)

@onready var ring_test = $ring_test
@onready var ring_page = 0
@onready var all_ring_data = ring_test.db.select_rows("ring", "id > 0", ["*"])
@onready var search_ring_data = ring_test.db.select_rows("ring", "id > 0", ["*"])
var object_delete = load("res://scr/UI/object_delete.gd").new()

func _ready():
	ring_test.hide()
	_page_update()

func _page_update():	#刷新頁面
	for child in self.get_children():
		if child.name != "ring_test":
			child.queue_free()
	var count = ring_page * 6
	while count < ring_page * 6 + 6 and count < search_ring_data.size():
		_add_ring(count)
		count += 1

func refresh():
	all_ring_data = ring_test.db.select_rows("ring", "id > 0", ["*"])
	search_ring_data = all_ring_data
	ring_page = 0# 可選，刷新時回到第一頁
	_page_update()
		
func _search_ring(keyword):
	var count = 0
	var check = true
	if keyword == "":
		check = false
	search_ring_data = []
	for child in self.get_children():
		if child.name != "ring_test":
			child.queue_free()
	while count < all_ring_data.size() and check:
		if keyword in all_ring_data[count]["name"]:
			search_ring_data.append(all_ring_data[count])
		count += 1
	if check != true:
		search_ring_data = all_ring_data
	print(search_ring_data)
	_page_update()

func _page_change(x):	#換頁
	if ring_page + x >= 0 and search_ring_data.size() > (ring_page + x) * 6:
		ring_page += x
		print(ring_page)
		_page_update()
	else:
		print("OVER")

func _add_ring(ring_n):	#顯示每個狀態
	var new_ring = ring_test.duplicate()
	new_ring.name = "new_ring" + str(ring_n)
	add_child(new_ring)
	new_ring.show()
	new_ring.get_node("PC/VBC/ring_name").text = str(search_ring_data[ring_n]["name"])
	new_ring.get_node("PC/VBC/ring_id").text = "狀態階級：" + str(search_ring_data[ring_n]["id"])
	new_ring.get_node("PC/VBC/ring_level").text = "狀態階級：" + str(search_ring_data[ring_n]["level"])
	new_ring.get_node("PC/VBC/ring_health").text = "生命值：" + str(search_ring_data[ring_n]["health"])
	new_ring.get_node("PC/VBC/ring_attack_power").text = "物理攻擊：" + str(search_ring_data[ring_n]["attack_power"])
	new_ring.get_node("PC/VBC/ring_magic_power").text = "魔法攻擊：" + str(search_ring_data[ring_n]["magic_power"])
	new_ring.get_node("PC/VBC/ring_attack_defence").text = "物理防禦：" + str(search_ring_data[ring_n]["attack_defence"])
	new_ring.get_node("PC/VBC/ring_magic_defence").text = "魔法防禦：" + str(search_ring_data[ring_n]["magic_defence"])
	new_ring.get_node("ring_del/Button").pressed.connect(Callable(self, "_on_ring_delete_pressed").bind(str(search_ring_data[ring_n]["id"])))

func _on_ring_delete_pressed(ring_id):
	# 查詢該 ring 的 level
	var ring_data = ring_test.db.select_rows("ring", "id = " + str(ring_id), ["level"])
	if ring_data.size() == 0:
		return
	var level = ring_data[0]["level"]
	# 查詢該 level 有幾筆資料
	var level_count = ring_test.db.select_rows("ring", "level = " + str(level), ["id"])
	if level_count.size() <= 1:
		# 呼叫 ui_manage_change_ring 的 show_alert
		show_alert.emit("❌ 不可把一個等級的光環刪除至低於3個")
		return
	# 正常刪除
	print("deleted")
	object_delete._object_delete(ring_test.db, "ring", str(ring_id))
	search_ring_data = object_delete._refresh_database(ring_test.db, "ring")
	_page_update()
