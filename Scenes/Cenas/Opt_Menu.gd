extends Control

func _ready():
	$Music.value = GlobalVals.db_music_value
	$Sound.value = GlobalVals.db_fx_value
	
	$Title.text = "_option"
	$Music/Label.text = "_music_l"
	$Sound/Label.text = "_sound_l"

func _on_Music_value_changed(value):
	GlobalVals.db_music_value = value

func _on_Sound_value_changed(value):
	GlobalVals.db_fx_value = value

func _on_Exit_Button_pressed():
	get_tree().change_scene("res://Scenes/Cenas/Menu.tscn")

func _on_CheckButton_toggled(button_pressed):
	pass # Replace with function body.

func _on_OptionButton_item_selected(id):
	pass # Replace with function body.
