extends Control

#Signal
signal quit
signal restart

var show_ad = false

func _ready():
	
	connect("quit", get_parent(), "_on_QuitGame")
	connect("restart", get_parent(), "_on_RestartGame")
	
	$VBoxContainer/HBoxContainer/Button_Leave/TouchScreenButton.connect("pressed", self, "_Quit_Pressed")
	$VBoxContainer/HBoxContainer/Button_Restart/TouchScreenButton.connect("pressed", self, "_Restart_Pressed")
	
	#Localization
	$VBoxContainer/HBoxContainer/Button_Leave/Label.text = tr("_quit")
	$VBoxContainer/HBoxContainer/Button_Restart/Label.text = tr("_restart")
	$VBoxContainer/Title.text = tr("_game_over")

func _process(delta):
	
	if GlobalVals.db_music_value != $AudioStreamPlayer.volume_db:
		$AudioStreamPlayer.volume_db = GlobalVals.db_music_value

#Signal Processes

func _Quit_Pressed():
	emit_signal("quit")

func _Restart_Pressed():
	emit_signal("restart")

func _on_Admob_interstitial_loaded():
	if show_ad:
		$Admob.show_interstitial()
		show_ad = false
	

func _on_Admob_insterstitial_failed_to_load(error_code):
	print("Insterstitial error:" + str(error_code))

func _on_Admob_interstitial_closed():
	print("closed")

func _on_Game_Over_visibility_changed():
	if is_visible_in_tree():
		$AudioStreamPlayer.play()
		$Admob.load_interstitial()
		show_ad = true
	else:
		$AudioStreamPlayer.stop()
