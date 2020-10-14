extends Control

func _ready():
	
	$Easy_Button/Label.text = "Fácil"
	$Normal_Button/Label.text = "Normal"
	$Hard_Button/Label.text = "Dificil"
	

func _on_Easy_Button__pressed():
	GlobalVals.dificuldade = "e"
	
	if GlobalVals.first_time:
		get_tree().change_scene("res://Scenes/UI/Tutorial.tscn")
	else:
		get_tree().change_scene("res://Scenes/Cenas/Main Scene.tscn")

func _on_Normal_Button__pressed():
	GlobalVals.dificuldade = "n"
	
	if GlobalVals.first_time:
		get_tree().change_scene("res://Scenes/UI/Tutorial.tscn")
	else:
		get_tree().change_scene("res://Scenes/Cenas/Main Scene.tscn")

func _on_Hard_Button__pressed():
	GlobalVals.dificuldade = "h"
	
	if GlobalVals.first_time:
		get_tree().change_scene("res://Scenes/UI/Tutorial.tscn")
	else:
		get_tree().change_scene("res://Scenes/Cenas/Main Scene.tscn")
