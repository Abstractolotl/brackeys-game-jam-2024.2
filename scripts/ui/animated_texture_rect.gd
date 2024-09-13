extends TextureRect
class_name AnimatedTextureRect

@export var sprites: SpriteFrames
@export var animation: String = "default"
@export var frame_index: int = 0

func _ready() -> void:
	texture = sprites.get_frame_texture(animation, frame_index)

func go_to_frame(frame: int):
	frame_index = frame
	texture = sprites.get_frame_texture(animation, frame)
