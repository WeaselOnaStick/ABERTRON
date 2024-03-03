@tool
extends Sprite2D

@export var scroll_speed := 1.0

func _process(delta):
	texture.noise.offset.x += scroll_speed * delta
