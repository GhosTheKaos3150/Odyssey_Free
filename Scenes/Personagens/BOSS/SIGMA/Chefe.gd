extends Area2D

#Signals
signal life_update(life)
signal hipercannon
signal pause(state)
signal free

#Atributes

var life = 50
var type = "Boss"
var creator = "Nostradamus Base"

#Boss Functions

func _hipercannon_shot():
	var shot = load("res://Scenes/Tiros/laser_mk1/laser_mk1.tscn").instance()
	var shot2 = load("res://Scenes/Tiros/laser_mk1/laser_mk1.tscn").instance()
	
	#Shot1
	shot.scale.x = 2
	shot.scale.y = 2
	
	shot.atk = 5
	shot.creator = "Boss"
	shot.yangle = 1
	shot.xangle = 0
	shot.position.x = 55
	shot.position.y = 260+100
	shot.Srange = 5
	
	connect("pause", shot, "_pause")
	connect("free", shot, "_kill")
	
	#Shot2
	
	shot2.scale.x = 2
	shot2.scale.y = 2
	
	shot2.atk = 5
	shot2.creator = "Boss"
	shot2.yangle = 1
	shot2.xangle = 0
	shot2.position.x = 485
	shot2.position.y = 260+100
	shot2.Srange = 5
	
	connect("pause", shot2, "_pause")
	connect("free", shot2, "_kill")
	
	$Sound.stream = load("res://Assets/Sons/Laser_Shoot3.wav")
	#End
	get_parent().add_child(shot)
	$Sound.play()
	get_parent().add_child(shot2)
	$Sound.play()

func create_shot(posx, posy, lv):
	var shot = load("res://Scenes/Tiros/round_mk1/round_mk1.tscn").instance()
	
	if lv == 1:
		shot.scale.x = 2
		shot.scale.y = 2
	
	shot.atk = 5
	shot.creator = "Boss"
	shot.yangle = 1
	shot.xangle = 0
	shot.position.x = posx
	shot.position.y = posy
	
	connect("pause", shot, "_pause")
	connect("free", shot, "_kill")
	
	get_parent().add_child(shot)
	
	$Sound.stream = load("res://Assets/Sons/Laser_Shoot2.wav")
	$Sound.play()
	$Recharge.start()

func create_shotALT(posx, posy):
	var shot = load("res://Scenes/Tiros/round_mk2/round_mk2.tscn").instance()
	
	shot.atk = 5
	shot.creator = "Boss"
	shot.yangle = 1
	shot.xangle = 0
	shot.position.x = posx
	shot.position.y = posy
	
	connect("pause", shot, "_pause")
	connect("free", shot, "_kill")
	
	$Sound.stream = load("res://Assets/Sons/Laser_Shoot2.wav")
	$Sound.play()
	get_parent().add_child(shot)

#Cannons

func _on_LV1_Cannons_Timer_timeout():
	
	var rand = rand_range(0,1)
	
	if rand < 0.5:
		create_shot(135,230+100, 1)
	
	if rand >= 0.5:
		create_shot(405,230+100, 1)
	

func _on_LV2_Cannons_Timer_timeout():
	
	var rand = rand_range(0,1)
	
	if rand < 0.5:
		create_shot(170,260+100, 2)
	
	if rand >= 0.5:
		create_shot(370,260+100, 2)

func _on_LV3_Cannons_Timer_timeout():
	var rand = rand_range(0,1)
	
	if rand < 0.5:
		create_shotALT(248,280+100)
	
	if rand >= 0.5:
		create_shotALT(292,280+100)

func _on_Hipercannon_Timer_timeout():
	
	$LV1_Cannons_Timer.stop()
	$LV2_Cannons_Timer.stop()
	$LV3_Cannons_Timer.stop()
	
	_hipercannon_shot()
	emit_signal("hipercannon")

func _on_Recharge_timeout():
	
	$LV1_Cannons_Timer.start()
	$LV2_Cannons_Timer.start()
	$LV3_Cannons_Timer.start()
	
	$Hipercannon_Timer.start()

func _on_AnimationPlayer_animation_finished(anim_name):
	$LV1_Cannons_Timer.start()
	$LV2_Cannons_Timer.start()
	$LV3_Cannons_Timer.start()
	
	$Hipercannon_Timer.start()

# Game Processes

func _pause(state):
	
	if state:
		$Hipercannon_Timer.paused = true
		$LV1_Cannons_Timer.paused = true
		$LV2_Cannons_Timer.paused = true
		$LV3_Cannons_Timer.paused = true
		$Recharge.paused = true
		
	else: 
		$Hipercannon_Timer.paused = false
		$LV1_Cannons_Timer.paused = false
		$LV2_Cannons_Timer.paused = false
		$LV3_Cannons_Timer.paused = false
		$Recharge.paused = false
	
	emit_signal("pause", state)
