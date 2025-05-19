extends GridContainer

@onready var ring_test = $ring_test
@onready var ring_n = 0
@onready var ring_data = ring_test.db.select_rows("ring", "id > 0", ["*"])

func _ready():
	ring_test.hide()
	while ring_n == 0 or ring_n%6!=0:
		_add_ring()
		ring_n += 1
	
func _add_ring():
	print(ring_n)
	var new_ring = ring_test.duplicate()
	new_ring.name = "new_ring" + str(ring_n)
	add_child(new_ring)
	new_ring.show()
	new_ring.get_node("PC/VBC/ring_name").text = str(ring_data[ring_n]["name"])
	new_ring.get_node("PC/VBC/ring_level").text = "光環階級：" + str(ring_data[ring_n]["level"])
	new_ring.get_node("PC/VBC/ring_health").text = "生命值：" + str(ring_data[ring_n]["health"])
	new_ring.get_node("PC/VBC/ring_attack_power").text = "物理攻擊：" + str(ring_data[ring_n]["attack_power"])
	new_ring.get_node("PC/VBC/ring_magic_power").text = "魔法攻擊：" + str(ring_data[ring_n]["magic_power"])
	new_ring.get_node("PC/VBC/ring_attack_defence").text = "物理防禦：" + str(ring_data[ring_n]["attack_defence"])
	new_ring.get_node("PC/VBC/ring_magic_defence").text = "魔法防禦：" + str(ring_data[ring_n]["magic_defence"])
