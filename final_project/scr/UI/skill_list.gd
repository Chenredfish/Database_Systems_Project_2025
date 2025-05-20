extends GridContainer

signal next_page_pressed
signal previous_page_pressed

@onready var skill_test = $skill_test
@onready var skill_page = 0
@onready var skill_data = skill_test.db.select_rows("skill", "id > 0", ["*"])

func _ready():
	skill_test.hide()
	_page_update()

func _page_update():	#刷新頁面
	for child in self.get_children():
		if child.name != "skill_test":
			child.queue_free()
	var count = skill_page * 6
	while count < skill_page * 6 + 6 and count < skill_data.size():
		_add_skill(count)
		count += 1
		

func _page_change(x):	#換頁
	if skill_page + x >= 0 and skill_data.size() > (skill_page + x) * 6:
		skill_page += x
		print(skill_page)
		_page_update()
	else:
		print("OVER")
		

func _add_skill(skill_n):	#顯示每個狀態
	var new_skill = skill_test.duplicate()
	new_skill.name = "new_skill" + str(skill_n)
	add_child(new_skill)
	new_skill.show()
	new_skill.get_node("PC/VBC/skill_name").text = str(skill_data[skill_n]["name"])
	new_skill.get_node("PC/VBC/skill_level").text = "技能階級：" + str(skill_data[skill_n]["level"])
	new_skill.get_node("PC/VBC/skill_element").text = "屬性：" + str(skill_data[skill_n]["element"])
	if skill_data[skill_n]["is_magic"] == 1:
		new_skill.get_node("PC/VBC/skill_is_magic").text = "攻擊類別：魔法"
	else:
		new_skill.get_node("PC/VBC/skill_is_magic").text = "攻擊類別：物理"
	new_skill.get_node("PC/VBC/skill_power").text = "攻擊係數：" + str(skill_data[skill_n]["power"])
	new_skill.get_node("PC/VBC/skill_cooldown").text = "技能冷卻：" + str(skill_data[skill_n]["cooldown"])
