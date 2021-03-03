extends Control

func _ready():
	$Music.value = Global.db_music_value
	$Sound.value = Global.db_fx_value
	
	$Title.text = "_option"
	$Music/Label.text = "_music_l"
	$Sound/Label.text = "_sound_l"
	$CheckButton.text = "_df_default"
	$OptionButton/Label.text = "_df_opt_menu"
	
	$CheckButton.pressed = Global.dificuty_check
	
	$OptionButton.add_item("Fácil", 0)
	$OptionButton.add_item("Normal", 1)
	$OptionButton.add_item("Difícil", 2)
	
	match Global.dificuldade:
		"e": 
			$OptionButton.selected = 0
		"n": 
			$OptionButton.selected = 1
		"h": 
			$OptionButton.selected = 2
	
	match Global.dificuty_check:
		true: $OptionButton.show()
		false: $OptionButton.hide()

func _on_Music_value_changed(value):
	Global.db_music_value = value

func _on_Sound_value_changed(value):
	Global.db_fx_value = value

func _on_Exit_Button_pressed():
	Global._save()
	get_tree().change_scene("res://Scenes/Cenas/Menu.tscn")

func _on_CheckButton_toggled(button_pressed):
	Global.dificuty_check = button_pressed
	
	match button_pressed:
		true: $OptionButton.show()
		false: $OptionButton.hide()
	
	Global._save()

func _on_OptionButton_item_selected(id):
	if id >= 0:
		match id:
			0: 
				Global.dificuldade = "e"
			1: 
				Global.dificuldade = "n"
			2: 
				Global.dificuldade = "h"
		Global._save()
