extends GridContainer

signal next_page_pressed
signal previous_page_pressed
signal show_alert(msg:String)
signal skill_edit(skill)

@onready var skill_test = $skill_test
@onready var skill_page = 0
@onready var all_skill_data = skill_test.db.select_rows("skill", "id > 0", ["*"])
@onready var search_skill_data = skill_test.db.select_rows("skill", "id > 0", ["*"])
var object_delete = load("res://scr/UI/object_delete.gd").new()

func _ready():
	skill_test.hide()
	_page_update()

func _page_update():	#刷新頁面
	for child in self.get_children():
		if child.name != "skill_test":
			child.queue_free()
	var count = skill_page * 6
	while count < skill_page * 6 + 6 and count < search_skill_data.size():
		_add_skill(count)
		count += 1
		
		
func refresh():
	all_skill_data = skill_test.db.select_rows("skill", "id > 0", ["*"])
	search_skill_data = all_skill_data
	skill_page = 0# 可選，刷新時回到第一頁
	_page_update()

func _page_change(x):	#換頁
	if skill_page + x >= 0 and search_skill_data.size() > (skill_page + x) * 6:
		skill_page += x
		print(skill_page)
		_page_update()
	else:
		print("OVER")
		
func _search_skill(keyword):
	var count = 0
	var check = true
	if keyword == "":
		check = false
	search_skill_data = []
	for child in self.get_children():
		if child.name != "skill_test":
			child.queue_free()
	while count < all_skill_data.size() and check:
		if keyword in all_skill_data[count]["name"]:
			search_skill_data.append(all_skill_data[count])
		count += 1
	if check != true:
		search_skill_data = all_skill_data
	print(search_skill_data)
	_page_update()

func _add_skill(skill_n):	#顯示每個狀態
	var new_skill = skill_test.duplicate()
	new_skill.name = str(search_skill_data[skill_n]["id"])
	add_child(new_skill)
	new_skill.show()
	new_skill.get_node("PC/VBC/skill_name").text = str(search_skill_data[skill_n]["name"])
	new_skill.get_node("PC/VBC/skill_id").text = "技能代號：" + str(search_skill_data[skill_n]["id"])
	new_skill.get_node("PC/VBC/skill_level").text = "技能階級：" + str(search_skill_data[skill_n]["level"])
	new_skill.get_node("PC/VBC/skill_element").text = "屬性：" + str(search_skill_data[skill_n]["element"])
	#if str(search_skill_data[skill_n]["element"]) == "草":
		#new_skill.get_node("PC/skill_element_texture").atlas.region = Rect2(416, 404.5, 179, 205)
	if int(search_skill_data[skill_n]["is_magic"]) == 1:
		new_skill.get_node("PC/VBC/skill_is_magic").text = "攻擊類別：魔法"
	else:
		new_skill.get_node("PC/VBC/skill_is_magic").text = "攻擊類別：物理"
	new_skill.get_node("PC/VBC/skill_power").text = "攻擊係數：" + str(search_skill_data[skill_n]["power"])
	new_skill.get_node("PC/VBC/skill_cooldown").text = "技能冷卻：" + str(search_skill_data[skill_n]["cooldown"])
	new_skill.get_node("HBC/skill_del/Button").pressed.connect(Callable(self, "_on_skill_delete_pressed").bind(str(search_skill_data[skill_n]["id"])))
	new_skill.get_node("HBC/skill_edit/Button").pressed.connect(Callable(self, "_on_skill_edit_pressed").bind(search_skill_data[skill_n]))

func _on_skill_delete_pressed(skill_id):
	# 查詢該 actor 的 level
	var skill_data = skill_test.db.select_rows("skill", "id = " + str(skill_id), ["level"])
	if skill_data.size() == 0:
		return
	var level = skill_data[0]["level"]
	# 查詢該 level 有幾筆資料
	var level_count = skill_test.db.select_rows("skill", "level = " + str(level), ["id"])
	if level_count.size() <= 3:
		# 呼叫 ui_manage_change_actor 的 show_alert
		show_alert.emit("❌ 不可把一個等級的角色刪除至低於3個")
		return
	# 正常刪除
	object_delete._object_delete(skill_test.db, "skill", str(skill_id))
	search_skill_data = object_delete._refresh_database(skill_test.db, "skill")
	_page_update()

func _on_skill_edit_pressed(target_skill):
	skill_edit.emit(target_skill)
