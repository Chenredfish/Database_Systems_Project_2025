extends Node2D
class_name IdleAnimation

@export var animation_frames_path: String = ""
@export var anim_name: String = "idle"
@export var anim_speed: float = 7.0
@export var anim_loop: bool = true
@export var sprite_scale: Vector2 = Vector2(1.0, 1.0)
@export var sprite_position: Vector2 = Vector2.ZERO 

var animated_sprite = AnimatedSprite2D
