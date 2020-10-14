extends Control

signal return_(state)

var type = ""
var Title: String
var Content: String

func _ready():
	connect("return_", get_parent().get_parent(), "_on_GUI_notify_pause")
	emit_signal("return_", true)
	
	if type == "":
		type = "ShieldT"
	
	_on_added()

func _on_added():
	match type:
		"TripleT": 
			Title = "_popup_triple"
			Content = "_popup_triple_msg"
		"QuadT": 
			Title = "_popup_quad"
			Content = "_popup_quad_msg"
		"Laser1": 
			Title = "_popup_laser"
			Content = "_popup_laser_msg"
		"BulletT": 
			Title = "_popup_bullet"
			Content = "_popup_bullet_msg"
		"MegaT":
			Title = "_popup_mega"
			Content = "_popup_mega_msg"
		"LifeT":
			Title = "_popup_life"
			Content = "_popup_life_msg"
		"LifeUpT":
			Title = "_popup_life+"
			Content = "_popup_life+_msg"
		"AtackUpT":
			Title = "_popup_atk+"
			Content = "_popup_atk+_msg"
		"ShieldT":
			Title = "_popup_shield"
			Content = "_popup_shield_msg"
	
	$Title.text = Title
	$Content.text = Content

func _on_TouchScreenButton_pressed():
	emit_signal("return_", false)
	queue_free()
