extends Popup

#Signals
signal accepted
signal denied

#Atributes
var prompt_label = ""

#Dialog Processes

func _ready():
	
	$Message.text = prompt_label
	connect("accepted", get_parent(), "_DialogPopup_Accepted")

func _process(delta):
	if Global.db_fx_value != $Sound_POPUP.volume_db:
		$Sound_POPUP.volume_db = Global.db_fx_value
	
	if Global.db_fx_value != $Sound_SELECTION.volume_db:
		$Sound_SELECTION.volume_db = Global.db_fx_value

func _on_Confirmation_Dialog_about_to_show():
	$Sound_POPUP.play()
	$Message.text = prompt_label
	$AnimationPlayer.play("Show")
	

#Signals Processes

func _on_Accept_pressed():
	emit_signal("accepted")
	Global._save()

func _on_Deny_pressed():
	emit_signal("denied")
	hide()

func _on_Menu_quit_pressed():
	popup()
