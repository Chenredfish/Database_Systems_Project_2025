extends Node
class_name BaseStateMachine

var current_state_index:int = 0 #現在的狀態索引 #初始是0
var current_state:BaseState: #現在的狀態 #初始是引所為0的狀態
	get:
		return states[current_state_index]

var states:Dictionary={} #狀態
var values:Dictionary={} #狀態需要獲取的值

##狀態機代理
@export var agent:Node #沒有給予初始狀態就報錯

var is_run:bool = false #狀態機是否仍然在執行

#暫停時狀態機仍然運作
func _enter_tree():
	self.process_mode = PROCESS_MODE_ALWAYS


##執行對應狀態
func _process(delta)->void:
	current_state.update(delta)
	

#狀態機啟動
func launch(state_index:int = 0):
	assert(agent, '代理不能為空') #assert第一項如果為false，程式直接停止
	is_run=true
	
	current_state = states[state_index]
	current_state.enter()

#增加狀態機內的狀態
func add_state(state_type_index:int, state:BaseState)->void:
	states[state_type_index] = state

#設置狀態機內的數值
func set_value(name:StringName, value:Variant): #Variant自由的變數，會自己更改
	values[name]=value
	
#刪除狀態機內的數值
func delete_value(name:StringName): #Variant自由的變數，會自己更改
	if values.has(name):
		values.erase(name)

#獲得狀態機內的數值
func get_value(name:StringName)->Variant:
	if values.has(name):
		return values[name]
	else:
		return null


func has_value(name:StringName)->bool:
	return values.has(name)
