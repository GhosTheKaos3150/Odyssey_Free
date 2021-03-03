extends Control

#Signal
signal quit
signal restart

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
	
	if Global.db_music_value != $AudioStreamPlayer.volume_db:
		$AudioStreamPlayer.volume_db = Global.db_music_value

#Signal Processes

func _Quit_Pressed():
	emit_signal("quit")

func _Restart_Pressed():
	emit_signal("restart")

func _on_Game_Over_visibility_changed():
	if is_visible_in_tree():
		$AudioStreamPlayer.play()
	
	else:
		$AudioStreamPlayer.stop()

func _on_Game_Over_hide():
	$AudioStreamPlayer.stop()
