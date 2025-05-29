extends Node2D
class_name IdleAnimation

@export var animation_base_path: String
@export var subfolder_prefix: String

# 重新引入這些變數，並可選擇性地重新 @export，因為敵人會用到
@export var subfolder_id_min: int = 1
@export var subfolder_id_max: int = 1

@export var anim_name: String = "idle"
@export var anim_speed: float = 7.0
@export var anim_loop: bool = true

@export var sprite_scale: Vector2
@export var sprite_position: Vector2
@export var sprite_z_index: int
@export var flip_horizontally: bool

var animated_sprite: AnimatedSprite2D

const ELEMENT_TO_ID_MAP = {
	"火": 1,
	"水": 2,
	"草": 3,
	"光": 4,
	"暗": 5
}

func _ready():
	animated_sprite = AnimatedSprite2D.new()
	add_child(animated_sprite) 

	animated_sprite.position = sprite_position
	animated_sprite.scale = sprite_scale
	animated_sprite.z_index = sprite_z_index
	animated_sprite.flip_h = flip_horizontally

	var selected_anim_id: int = -1
	
	# 判斷是玩家還是敵人，並依此決定動畫 ID 來源
	if get_parent() and get_parent() is Actor:
		var parent_actor = get_parent()
		if parent_actor.level == 0: # 這是玩家
			var player_element = parent_actor.element
			selected_anim_id = get_anim_id_from_element(player_element)
			if selected_anim_id == -1:
				push_warning("玩家元素 '" + str(player_element) + "' 無法對應到動畫 ID。請檢查元素名稱或 ELEMENT_TO_ID_MAP。")
		else: # 這是敵人 (level != 0)
			# 使用之前設定的 subfolder_id_min/max 進行隨機選擇
			selected_anim_id = randi_range(subfolder_id_min, subfolder_id_max)
			randomize() # 確保每次運行都重新初始化隨機數生成器
	else:
		push_warning("IdleAnimation 的父節點不是 Actor 類型或不存在。無法獲取 Actor 的層級或元素資訊。")

	if selected_anim_id != -1:
		var full_animation_path = animation_base_path + subfolder_prefix + str(selected_anim_id) + "/"
		setup_animation(full_animation_path, selected_anim_id)
	else:
		push_warning("無法確定動畫 ID，未載入動畫。")


func get_anim_id_from_element(element: String) -> int:
	if ELEMENT_TO_ID_MAP.has(element):
		return ELEMENT_TO_ID_MAP[element]
	return -1

func setup_animation(path_to_load: String, selected_id: int): 
	if path_to_load.is_empty():
		push_warning("動畫幀路徑為空！無法載入動畫。")
		animated_sprite.sprite_frames = null
		return

	var frames = SpriteFrames.new()
	animated_sprite.sprite_frames = frames

	load_animation_frames(frames, anim_name, path_to_load)

	if frames.has_animation(anim_name):
		if animated_sprite.animation != anim_name or not animated_sprite.is_playing():
			animated_sprite.play(anim_name)
	else:
		push_warning("動畫名稱 '" + anim_name + "' 不存在於 SpriteFrames 中。")
		animated_sprite.sprite_frames = null


func load_animation_frames(sprite_frames_res: SpriteFrames, anim_name_to_add: String, path: String):
	sprite_frames_res.add_animation(anim_name_to_add)
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("無法打開動畫資料夾: " + path + ". 請檢查路徑和檔案是否存在。")
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	var file_names_to_load = []
	while file_name != "":
		if not dir.current_is_dir() and (file_name.ends_with(".png") || file_name.ends_with(".webp")):
			file_names_to_load.append(file_name)
		file_name = dir.get_next()
	dir.list_dir_end()

	file_names_to_load.sort()

	var loaded_frames_count = 0
	for f_name in file_names_to_load:
		var texture_path = path + f_name
		var tex = load(texture_path)
		if tex:
			sprite_frames_res.add_frame(anim_name_to_add, tex)
			loaded_frames_count += 1

	if loaded_frames_count == 0:
		push_warning("資料夾 '" + path + "' 中沒有找到任何圖片幀。")
		return

	sprite_frames_res.set_animation_speed(anim_name_to_add, anim_speed)
	sprite_frames_res.set_animation_loop(anim_name_to_add, anim_loop)
