extends Node

var play_game_service
var pgs_init: bool
var show_popups: bool
var enable_save_games: bool
var Acount_Connected: String

func _ready():
	show_popups = true
	enable_save_games = false
	pgs_init = false
	Acount_Connected = ""

#Callbacks

func _on_sign_in_sucess(acount_id: String):
	print ("sign in at " + acount_id + " success!")
	Acount_Connected = acount_id

func _on_sign_in_failed(error_code: int) -> void:
	print ("sign in failled with code: " + str(error_code))

func _on_sign_out_success():
	print ("sign out success")
  
func _on_sign_out_failed():
	print ("sign out failled")

func _on_achievement_unlocked(achievement: String):
	print ("achievement " + achievement + " unlocked")

func _on_achievement_unlocking_failed(achievement: String):
	print ("unlocking achievement " + achievement + " failled")

func _on_achievement_incremented(achievement: String):
	print ("incrementing achievement " + achievement + "succeded")

func _on_achievement_incrementing_failed(achievement: String):
	print ("failled to increment achievement " + achievement)

func _on_achievement_revealed(achievement: String):
	print ("achievement " + achievement + "revealed")

func _on_achievement_revealing_failed(achievement: String):
	print ("failled to reveal achievement " + achievement)

func _on_leaderboard_score_submitted(leaderboard_id: String):
	print("score submmited to " + leaderboard_id)

func _on_leaderboard_score_submitting_failed(leaderboard_id: String):
	print ("failled to submmit score to " + leaderboard_id)

func _on_player_is_already_connected(is_connected: bool):
	if is_connected:
		print ("Player is already connected!")
	else:
		print ("Player connecting...")

func _on_game_saved_success():
	print("Saving game file succeded")

func _on_game_saved_fail():
	print("Saving game file failled")

func _on_game_load_success(data):
	var game_data = parse_json(data)
	GlobalVals.first_time = game_data["first_time"]
	

func _on_game_load_fail():
	print ("Loading game file failled")

#Connection
func _connect_services():
	if Engine.has_singleton("PlayGameServices") and not pgs_init:
		play_game_service = Engine.get_singleton("PlayGameServices")
		
		play_game_service.init(get_instance_id(), show_popups, enable_save_games)
		pgs_init = true
