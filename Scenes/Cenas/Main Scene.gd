extends Node2D

signal start_game #Connect to warn a Game Start Event
signal end_game #Connect to warn a Game End Event
signal pause_game(state) #Connect to warn a Game Pause Evente. "state" must be boolean

#Instances
var Mob
var sys_score = 0
var score_lock = false

#Play Game Service
var play_game_service

#Scene Processes

func _ready():
#	emit_signal("start_game") #TEST ONLY
	$Admob.load_banner()
	$DEBUG.text = "DEBUG MSG Odyssey V0.7"
	$GUI/RechargeBar.max_value = $Player/ShotTimer.wait_time
	_start_game()
	_random_Mob()

func _process(delta):
	$GUI/RechargeBar.value = $Player/ShotTimer.time_left*100
	
#	if sys_score == 10:
#		Global.play_game_service.unlock_achievement("CgkIqeCtvvUHEAIQAg")
#	if sys_score == 50:
#		Global.play_game_service.unlock_achievement("CgkIqeCtvvUHEAIQAw")
	
	if $Sound_Game.volume_db != GlobalVals.db_music_value:
		$Sound_Game.volume_db = GlobalVals.db_music_value

func _score_locking():
	score_lock = !score_lock

func _start_game():
	#Evoke for game starts
	emit_signal("start_game")
	
	$Admob.load_banner()
	
	$Sound_Game.play()
	$Game_Over.hide()
	$Dialog_Back.hide()
	$GUI/RechargeBar.max_value = $Player/ShotTimer.wait_time*100
	$GUI/LifeBar.max_value = $Player.maxlife
	$GUI/LifeBar.value = $Player.life
	$MobSpawn/SpawnTimer.start()
	

func _end_game():
	
#	Global.play_game_service.submit_leaderboard_score("CgkIqeCtvvUHEAIQAQ", sys_score)
	
	$Admob.hide_banner()
	
	#Evoke for game end
	emit_signal("end_game")
	$Sound_Game.stop()
	$Dialog_Back.show()
	$Game_Over.show()
	$MobSpawn/SpawnTimer.stop()
	

func _self_debug(Dtext):
	$DEBUG.text += "\n Action Done on Main!" + Dtext

func _self_sendto_add(instance):
	add_child(instance)

func _DialogPopup_Accepted():
	$Dialog_Back.hide()
	$Confirmation_Dialog.hide()
	_start_game()
	
func _DialogPopup_Denied():
	get_tree().change_scene("res://Scenes/Cenas/Menu.tscn")

func _generate_mob():
	$MobSpawn/MobSpawnLocation.set_offset(randi())
	
	if Mob != load("res://Scenes/Personagens/Enemy/Spinner.tscn"):
		_random_Mob()
	
	var mob = Mob.instance()
	mob.position = $MobSpawn/MobSpawnLocation.position
	mob.position.x = clamp(mob.position.x , 86, 540-86)
	mob.position.y = 25
	mob.system_score = sys_score
	
	connect("pause_game", mob, "_pause")
	connect("end_game", mob, "_kill")
	
	_self_sendto_add(mob)
	
	var d2 = rand_range(0, 1)
	
	if d2 > 0.8 and sys_score >= 100 and Mob != load("res://Scenes/Personagens/Enemy/Spinner.tscn"):
		Mob = load("res://Scenes/Personagens/Enemy/Spinner.tscn")
		_generate_mob()
	elif Mob == load("res://Scenes/Personagens/Enemy/Spinner.tscn"):
		_random_Mob()

#Mob Processes

func _random_Mob():
	#Randomly changes the Mob
	randomize()
	var rand = int(rand_range(1, 10))
	
	Mob = null
	
	if GlobalVals.dificuldade == "e":
		match(rand):
			1, 2, 3:
				if sys_score >= 50:
					Mob = load("res://Scenes/Personagens/Enemy/Enemie_2.tscn")
				elif sys_score >= 150:
					Mob = load("res://Scenes/Personaens/Enemy/Jet.tscn")
				else:
					Mob = load("res://Scenes/Personagens/Enemy/Enemie_1.tscn")
			9:
				if sys_score >= 75:
					Mob = load("res://Scenes/Personagens/Enemy/Barrier.tscn")
				else:
					Mob = load("res://Scenes/Personagens/Enemy/Enemie_1.tscn")
			_: Mob = load("res://Scenes/Personagens/Enemy/Enemie_1.tscn")
	elif GlobalVals.dificuldade == "n":
		match(rand):
			1, 2, 3:
				if sys_score >= 25:
					Mob = load("res://Scenes/Personagens/Enemy/Jet.tscn")
				elif sys_score >= 125:
					Mob = load("res://Scenes/Personaens/Enemy/Jet.tscn")
				else:
					Mob = load("res://Scenes/Personagens/Enemy/Jet.tscn")
			9:
				if sys_score >= 50:
					Mob = load("res://Scenes/Personagens/Enemy/Barrier.tscn")
				else:
					Mob = load("res://Scenes/Personagens/Enemy/Enemie_1.tscn")
			_: Mob = load("res://Scenes/Personagens/Enemy/Enemie_1.tscn")
	elif GlobalVals.dificuldade == "h":
		match(rand):
			1, 2, 3:
				if sys_score >= 15:
					Mob = load("res://Scenes/Personagens/Enemy/Enemie_2.tscn")
				elif sys_score >= 115:
					Mob = load("res://Scenes/Personaens/Enemy/Jet.tscn")
				else:
					Mob = load("res://Scenes/Personagens/Enemy/Enemie_1.tscn")
			9:
				if sys_score >= 40:
					Mob = load("res://Scenes/Personagens/Enemy/Barrier.tscn")
				else:
					Mob = load("res://Scenes/Personagens/Enemy/Enemie_1.tscn")
			_: Mob = load("res://Scenes/Personagens/Enemy/Enemie_1.tscn")

func _on_SpawnTimer_timeout():
	
	if sys_score > 0 and sys_score % 100 == 0:
		var Boss = load("res://Scenes/Personagens/BOSS/THETA/Theta_Boss.tscn")
		
		if Boss != null:
			Boss = Boss.instance()
		else:
			print(Boss)
		
		connect("pause_game", Boss, "_pause")
		connect("end_game", Boss, "_kill")
		$MobSpawn/SpawnTimer.stop()
		
		add_child(Boss)
		_score_locking()
		
	elif sys_score > 0 and sys_score % 50 == 0:
		var Boss = load("res://Scenes/Personagens/BOSS/SIGMA/SIGMABoss.tscn")
		
		if Boss != null:
			Boss = Boss.instance()
		else:
			print(Boss)
		
		connect("pause_game", Boss, "_pause")
		connect("end_game", Boss, "_end_game")
		$MobSpawn/SpawnTimer.stop()
		
		add_child(Boss)
		_score_locking()
		
	else:
		_generate_mob()
	

func _on_Enemy_killed():
	if !score_lock:
		sys_score += 1
		$GUI._reload_label()
	
	if sys_score % 50 == 0:
		_score_locking()

func _on_Boss_dead():
	sys_score += 1
	$GUI._reload_label()
	
	$MobSpawn/SpawnTimer.start()

#Player Processes

func _on_Player_debug(Dtext):
	$DEBUG.text += "\n Action Done on Player!" + Dtext

func _on_Player_sendto_add(instance):
	add_child(instance, true)

func _on_Player_life_changed(life):
	$GUI/LifeBar.value = life

#GUI Processes

func _on_GUI_notify_pause(state):
	if state:
		$BackgroundA/AnimationPlayer.stop()
		$MobSpawn/SpawnTimer.stop()
		$Sound_Game.set_deferred("stream_paused", true)
		emit_signal("pause_game", true)
	else:
		$BackgroundA/AnimationPlayer.play("Background")
		$MobSpawn/SpawnTimer.start()
		$Sound_Game.set_deferred("stream_paused", false)
		emit_signal("pause_game", false)

func _on_GUI_notify_reload():
	emit_signal("end_game")
	emit_signal("start_game")

func _on_QuitGame():
	$Admob.hide_banner()
	get_tree().change_scene("res://Scenes/Cenas/Menu.tscn")

func _on_RestartGame():
	sys_score = 0
	_start_game()

#Item Processes

func _on_Usage_item(item):
	_on_Player_tutorial(item)
	if item == "LifeT" and $Player.life < 3:
		$Player.life += 1
		$GUI._reload_life($Player.life)
	if item == "LifeUpT" and $Player.maxlife < 10:
		$Player.maxlife += 1
		$Player.life = $Player.maxlife
		$GUI/LifeBar.max_value = $Player.maxlife
		$GUI._reload_life($Player.life)
	if item == "AtackUpT" and $Player.atk < 5:
		$Player.atk += 0.5
	if item == "BulletT" and $Player.weapon != "shot":
		$Player.Shot = load("res://Scenes/Tiros/round_mk1/round_mk1.tscn")
		$Player.main = "bullet"
		$Player.weapon = "single"
		$Player.delay_time = 0.5
	if item == "MegaT" and $Player.weapon != "mega":
		$Player.weapon = "mega"
		$Player.delay_time = 0.5
	if item == "TripleT" and $Player.weapon != "triple":
		$Player.weapon = "triple"
		$Player.delay_time = 0.8
	if item == "QuadT" and $Player.weapon != "quad":
		$Player.weapon = "quad"
		$Player.delay_time = 1
	if item == "Laser1" and $Player.weapon != "laser1":
		$Player.Shot = load("res://Scenes/Tiros/laser_mk1/laser_mk1.tscn")
		$Player.main = "laser"
		$Player.weapon = "single"
		$Player.delay_time = 0.5
	

func _on_Player_tutorial(type):
	match type:
		"TripleT": 
			if GlobalVals.tuto_capsule["triple"] == false:
				var tuto = load("res://Scenes/UI/Tutorial_Shots.tscn").instance()
				tuto.type = type
				$GUI.add_child(tuto)
				
				GlobalVals.tuto_capsule["triple"] = true
				GlobalVals._save()
		"QuadT": 
			if GlobalVals.tuto_capsule["quad"] == false:
				var tuto = load("res://Scenes/UI/Tutorial_Shots.tscn").instance()
				tuto.type = type
				$GUI.add_child(tuto)
				
				GlobalVals.tuto_capsule["quad"] = true
				GlobalVals._save()
		"Laser1": 
			if GlobalVals.tuto_capsule["laser"] == false:
				var tuto = load("res://Scenes/UI/Tutorial_Shots.tscn").instance()
				tuto.type = type
				$GUI.add_child(tuto)
				
				GlobalVals.tuto_capsule["laser"] = true
				GlobalVals._save()
		"BulletT": 
			if GlobalVals.tuto_capsule["bullet"] == false:
				var tuto = load("res://Scenes/UI/Tutorial_Shots.tscn").instance()
				tuto.type = type
				$GUI.add_child(tuto)
				
				GlobalVals.tuto_capsule["bullet"] = true
				GlobalVals._save()
		"MegaT":
			if GlobalVals.tuto_capsule["mega"] == false:
				var tuto = load("res://Scenes/UI/Tutorial_Shots.tscn").instance()
				tuto.type = type
				$GUI.add_child(tuto)
				
				GlobalVals.tuto_capsule["mega"] = true
				GlobalVals._save()
		"LifeT":
			if GlobalVals.tuto_capsule["life"] == false:
				var tuto = load("res://Scenes/UI/Tutorial_Shots.tscn").instance()
				tuto.type = type
				$GUI.add_child(tuto)
				
				GlobalVals.tuto_capsule["life"] = true
				GlobalVals._save()
		"LifeUpT":
			if GlobalVals.tuto_capsule["lifeplus"] == false:
				var tuto = load("res://Scenes/UI/Tutorial_Shots.tscn").instance()
				tuto.type = type
				$GUI.add_child(tuto)
				
				GlobalVals.tuto_capsule["lifeplus"] = true
				GlobalVals._save()
		"AtackUpT":
			if GlobalVals.tuto_capsule["attackplus"] == false:
				var tuto = load("res://Scenes/UI/Tutorial_Shots.tscn").instance()
				tuto.type = type
				$GUI.add_child(tuto)
				
				GlobalVals.tuto_capsule["attackplus"] = true
				GlobalVals._save()
		"ShieldT":
			if GlobalVals.tuto_capsule["shield"] == false:
				var tuto = load("res://Scenes/UI/Tutorial_Shots.tscn").instance()
				tuto.type = type
				$GUI.add_child(tuto)
				
				GlobalVals.tuto_capsule["shield"] = true
				GlobalVals._save()
	
