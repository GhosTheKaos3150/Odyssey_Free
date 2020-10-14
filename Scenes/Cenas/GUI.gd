extends CanvasLayer

#Signals
signal notify_pause(state)
signal notify_reload
signal quit

#GUI Atributes
var pontuation
var paused

#GUI Processes

func _ready():
	pontuation = 0
	
	$Pause_Menu/FX_Slider.value = GlobalVals.db_fx_value
	$Pause_Menu/Music_Slider.value = GlobalVals.db_fx_value
	
	connect("quit", get_parent(), "_on_QuitGame")
	
	#Localization
	$Pause_Menu/Pause_Title.text = tr("_paused")
	$Pause_Menu/Reload/Label.text = tr("_restart")
	$Pause_Menu/FX_Slider/sound_label.text = tr("_sound_l")
	$Pause_Menu/Music_Slider/music_label.text = tr("_music_l")
	
	$Pause_Menu.hide()
	$Label.text = str(pontuation)

func _process(delta):
	
	if $Sound_Music.volume_db != GlobalVals.db_music_value:
		$Sound_Music.volume_db = GlobalVals.db_music_value
	
	if $Sound_SELECTION.volume_db != GlobalVals.db_fx_value:
		$Sound_SELECTION.volume_db = GlobalVals.db_fx_value

func _reload_life(life):
	$LifeBar.value = life

func _reload_label():
	pontuation += 1
	$Label.text = str(pontuation)

#Game Options

func _on_Main_Scene_end_game():
	$Button_Menu.hide()
	$ColorRect.hide()
	$Label.hide()
	$LifeBar.hide()
	$RechargeBar.hide()
	pontuation = 0

func _on_Main_Scene_start_game():
	$Button_Menu.show()
	$ColorRect.show()
	$Label.show()
	$LifeBar.show()
	$RechargeBar.show()
	
	$Label.text = str(0)

#Signal Processes

func _on_Menu_pressed():
	$Sound_SELECTION.play()
	paused = !paused
	emit_signal("notify_pause", paused)
	
	if paused:
		$Sound_Music.play()
		$Pause_Menu.show()
	else:
		$Sound_Music.stop()
		$Pause_Menu.hide()

func _on_Button_Quit_pressed():
	$Sound_SELECTION.play()
	emit_signal("quit")
	get_tree().change_scene("res://Scenes/Cenas/Menu.tscn")

func _on_Reload_pressed():
	_on_Menu_pressed()
	pontuation = 0
	emit_signal("notify_reload")

func _on_Music_Slider_value_changed(value):
	GlobalVals.db_music_value = value

func _on_FX_Slider_value_changed(value):
	GlobalVals.db_fx_value = value
