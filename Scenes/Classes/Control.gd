extends Control

func _ready():
	
	$Titulo.text = tr("_df_msg")
	$Easy_Button/Label.text = tr("_df_easy")
	$Normal_Button/Label.text = tr("_df_normal")
	$Hard_Button/Label.text = tr("_df_hard")
	

func _on_Easy_Button__pressed():
	Global.dificuldade = "e"
	
	if Global.first_time:
		get_tree().change_scene("res://Scenes/UI/Tutorial.tscn")
	else:
		get_tree().change_scene("res://Scenes/Cenas/Main Scene.tscn")

func _on_Normal_Button__pressed():
	Global.dificuldade = "n"
	
	if Global.first_time:
		get_tree().change_scene("res://Scenes/UI/Tutorial.tscn")
	else:
		get_tree().change_scene("res://Scenes/Cenas/Main Scene.tscn")

func _on_Hard_Button__pressed():
	Global.dificuldade = "h"
	
	if Global.first_time:
		get_tree().change_scene("res://Scenes/UI/Tutorial.tscn")
	else:
		get_tree().change_scene("res://Scenes/Cenas/Main Scene.tscn")

func _on_out_pressed():
	hide()
