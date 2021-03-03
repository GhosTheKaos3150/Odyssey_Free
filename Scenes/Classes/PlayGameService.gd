extends Node

var pgs
var pgs_init: bool
var show_popups: bool
var Acount_Connected: String

func _ready():
	show_popups = true
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

#Connection
func _connect_services():
	pgs = Engine.get_singleton("GodotPlayGamesServices")
	
	if pgs != null:
		pgs.init(show_popups)
		pgs_init = true
		
		pgs.connect("_on_sign_in_success", self, "_on_sign_in_success") # account_id: String
		pgs.connect("_on_sign_in_failed", self, "_on_sign_in_failed") # error_code: int
		pgs.connect("_on_sign_out_success", self, "_on_sign_out_success") # no params
		pgs.connect("_on_sign_out_failed", self, "_on_sign_out_failed") # no params
		pgs.connect("_on_achievement_unlocked", self, "_on_achievement_unlocked") # achievement: String
		pgs.connect("_on_achievement_unlocking_failed", self, "_on_achievement_unlocking_failed") # achievement: String
		pgs.connect("_on_achievement_revealed", self, "_on_achievement_revealed") # achievement: String
		pgs.connect("_on_achievement_revealing_failed", self, "_on_achievement_revealing_failed") # achievement: String
		pgs.connect("_on_achievement_incremented", self, "_on_achievement_incremented") # achievement: String
		pgs.connect("_on_achievement_incrementing_failed", self, "_on_achievement_incrementing_failed") # achievement: String
		pgs.connect("_on_leaderboard_score_submitted", self, "_on_leaderboard_score_submitted") # leaderboard_id: String
		pgs.connect("_on_leaderboard_score_submitting_failed", self, "_on_leaderboard_score_submitting_failed") # leaderboard_id: String
