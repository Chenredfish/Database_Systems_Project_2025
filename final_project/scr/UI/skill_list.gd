extends GridContainer

signal next_page_pressed
signal previous_page_pressed

@onready var skill_test = $skill_test
@onready var skill_page = 0
@onready var all_skill_data = skill_test.db.select_rows("skill", "id > 0", ["*"])
@onready var search_skill_data = skill_test.db.select_rows("skill", "id > 0", ["*"])

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
	new_skill.name = "new_skill" + str(skill_n)
	add_child(new_skill)
	new_skill.show()
	new_skill.get_node("PC/VBC/skill_name").text = str(search_skill_data[skill_n]["name"])
	new_skill.get_node("PC/VBC/skill_level").text = "技能階級：" + str(search_skill_data[skill_n]["level"])
	new_skill.get_node("PC/VBC/skill_element").text = "屬性：" + str(search_skill_data[skill_n]["element"])
	#if str(search_skill_data[skill_n]["element"]) == "草":
		#new_skill.get_node("PC/skill_element_texture").atlas.region = Rect2(416, 404.5, 179, 205)
	if search_skill_data[skill_n]["is_magic"] == 1:
		new_skill.get_node("PC/VBC/skill_is_magic").text = "攻擊類別：魔法"
	else:
		new_skill.get_node("PC/VBC/skill_is_magic").text = "攻擊類別：物理"
	new_skill.get_node("PC/VBC/skill_power").text = "攻擊係數：" + str(search_skill_data[skill_n]["power"])
	new_skill.get_node("PC/VBC/skill_cooldown").text = "技能冷卻：" + str(search_skill_data[skill_n]["cooldown"])
