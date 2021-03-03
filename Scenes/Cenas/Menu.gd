extends Control

#Signals

var connected = false

#Menu Processes

func _ready():
	
	Global.times += 1

	#Connecting Google Play Game Services
	if PGS.pgs_init:
		connected = PGS.pgs.isSignedIn()

		match connected:
			false: 
				$Sign_in.normal = load("user://Assets/UI/Buttons/button_config2.png")
				$Label_Loged.text = PGS.Acount_Connected
			true:  
				$Sign_in.normal = load("user://Assets/UI/Buttons/button_config1.png")
				$Label_Loged.text = "Disconnected"

	else:
		PGS._connect_services()
		_sign_in()
	
	Global._load()
	
	$Confirmation_Dialog.prompt_label = tr("_confirmation_dialog")
	
	$Sound_POPUP.volume_db = Global.db_fx_value
	$Sound_Selection.volume_db = Global.db_fx_value
	
#	if Global.times > 2 and !Global.review:
#		InAppReview.review.startInAppReview()

func _process(delta):
	
	if Global.db_fx_value != $Sound_POPUP.volume_db:
		$Sound_POPUP.volume_db = Global.db_fx_value
	
	if Global.db_fx_value != $Sound_Selection.volume_db:
		$Sound_Selection.volume_db = Global.db_fx_value

func _DialogPopup_Accepted():
	get_tree().quit()

#Google Play Services

func _sign_in():
	if not connected and PGS.pgs != null:
		PGS.pgs.signIn()
		PGS.pgs.loadPlayerStats(true)
		connected = true
		$Sign_in.normal = load("res://Assets/UI/Buttons/button_config2.png")

func _sign_out():
	if connected and PGS.pgs != null:
		PGS.pgs.signOut()
		connected = false
		$Sign_in.normal = load("res://Assets/UI/Buttons/button_config1.png")

#Signal Processes

func _on_Play_pressed():
	$Sound_Selection.play()
	
	if Global.dificuty_check:
		if Global.first_time:
			get_tree().change_scene("res://Scenes/UI/Tutorial.tscn")
		else:
			get_tree().change_scene("res://Scenes/Cenas/Main Scene.tscn")
	else:
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
	if not PGS.pgs.isSignedIn():
		_sign_in()
	if PGS.pgs != null:
		PGS.pgs.showLeaderBoard("CgkIqeCtvvUHEAIQAQ")

func _on_Options_pressed():
	get_tree().change_scene("res://Scenes/Cenas/Opt_Menu.tscn")

func _on_Menu_tree_exiting():
	Global._save()
