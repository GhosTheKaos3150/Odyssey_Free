extends Control

#Signals
signal play_game
signal quit_pressed

var play_games_services
var connected = false

#Menu Processes

func _ready():
	
#	#Connecting Google Play Game Services
#	if Global.pgs_init:
#		connected = Global.play_game_service.is_player_connected()
#
#		match connected:
#			false: 
#				$Sign_in.normal = load("user://Assets/UI/Buttons/button_config2.png")
#				$Label_Loged.text = Global.Acount_Connected
#			true:  
#				$Sign_in.normal = load("user://Assets/UI/Buttons/button_config1.png")
#				$Label_Loged.text = "Disconnected"
#
#	else:
#		Global._connect_services()
#		_sign_in()
	
	GlobalVals._load()
	
	$Confirmation_Dialog.prompt_label = tr("_confirmation_dialog")
	connect("play_game", get_parent(), "_start_game")
	
	$Sound_POPUP.volume_db = GlobalVals.db_fx_value
	$Sound_Selection.volume_db = GlobalVals.db_fx_value

func _process(delta):
	
	if GlobalVals.db_fx_value != $Sound_POPUP.volume_db:
		$Sound_POPUP.volume_db = GlobalVals.db_fx_value
	
	if GlobalVals.db_fx_value != $Sound_Selection.volume_db:
		$Sound_Selection.volume_db = GlobalVals.db_fx_value

func _DialogPopup_Accepted():
	get_tree().quit()

#Google Play Services

func _sign_in():
	if not connected:
		Global.play_game_service.sign_in()
		Global.play_game_service.load_player_stats(true)
		connected = true
		$Sign_in.normal = load("res://Assets/UI/Buttons/button_config2.png")

func _sign_out():
	if connected:
		Global.play_game_service.sign_out()
		connected = false
		$Sign_in.normal = load("res://Assets/UI/Buttons/button_config1.png")

#Signal Processes

func _on_Play_pressed():
	$Sound_Selection.play()
	
	$D_Control.show()

func _on_Quit_pressed():
	$Confirmation_Dialog.popup()

func _on_creditos_pressed():
	get_tree().change_scene("res://Scenes/Cenas/Creditos/Creditos.tscn")

func _on_Sign_in_pressed():
	if connected:
		_sign_out()
	else:
		_sign_in()

func _on_Leaderboard_pressed():
	if not Global.play_game_service.is_player_connected():
		_sign_in()
	Global.play_game_service.show_leaderboard("CgkIqeCtvvUHEAIQAQ")

func _on_Options_pressed():
	get_tree().change_scene("res://Scenes/Cenas/Opt_Menu.tscn")

func _on_Menu_tree_exiting():
	GlobalVals._save()
