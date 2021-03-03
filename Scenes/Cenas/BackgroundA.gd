extends TextureRect

var speed = -0.3

func _ready():
	material.set_shader_param('scroll_speed', speed)
