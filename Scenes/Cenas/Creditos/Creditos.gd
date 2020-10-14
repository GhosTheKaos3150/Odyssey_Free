extends Control

var text_file = 0

func _ready():
	$Titulo.text = tr("_thx")
	
	var file = File.new()
	
	var err = file.open("res://THANKS_EN.txt", File.READ)
	
	if err == OK:
		$Credits.text = file.get_as_text()
	else:
		$Credits.text = "could not load: The File does not existd"
	

func change_text():
	
	match text_file:
		0:
			$Titulo.text = tr("_thx")
			
			var file = File.new()
			
			var err = file.open("res://THANKS_EN.txt", File.READ)
			
			if err == OK:
				$Credits.text = file.get_as_text()
			else:
				$Credits.text = "could not load: The File does not exist"
		1:
			$Titulo.text = tr("_copyright")
			
			var file = File.new()
			
			var err = file.open("res://COPYRIGHT.txt", File.READ)
			
			if err == OK:
				$Credits.text = file.get_as_text()
			else:
				$Credits.text = "could not load: The File does not exist"
		2: 
			$Titulo.text = tr("_changelog")
			
			var file = File.new()
			
			var err = file.open("res://CHANGELOG_EN.txt", File.READ)
			
			if err == OK:
				$Credits.text = file.get_as_text()
			else:
				$Credits.text = "could not load: The File does not exist"

func _on_out_pressed():
	$Click_sound.play()
	get_tree().change_scene("res://Scenes/Cenas/Menu.tscn")

func _on_less_pressed():
	
	$Click_sound.play()
	
	if text_file == 0:
		text_file = 2
	else:
		text_file -= 1
	
	change_text()

func _on_more_pressed():
	
	$Click_sound.play()
	
	if text_file == 2:
		text_file = 0
	else:
		text_file += 1
	
	change_text()
