extends Node

var db_music_value = -10
var db_fx_value = -10

var first_time = true
var dificuldade = "n"

var tuto_capsule = {
	
	"bullet" : false,
	"laser" : false,
	"triple" : false,
	"quad" : false,
	"mega" : false,
	"shield" : false,
	"attackplus": false,
	"lifeplus": false,
	"life": false
	
}

func _save():
	var save_file: Dictionary = { "first_time": first_time, "tutodef": tuto_capsule, "dificuldade": dificuldade}
	
	var save_game = File.new()
	
	save_game.open("user://nostradamus.save", File.WRITE)
	save_game.store_line(to_json(save_file))
	
	save_game.close()

func _load():
	var load_game = File.new()
	
	if load_game.file_exists("user://nostradamus.save"):
		load_game.open("user://nostradamus.save", File.READ)
		
		var load_data = parse_json(load_game.get_line())
		first_time = load_data["first_time"]
		print(load_data["tutodef"])
		tuto_capsule = load_data["tutodef"]
		dificuldade = load_data["dificuldade"]
		
		load_game.close()
