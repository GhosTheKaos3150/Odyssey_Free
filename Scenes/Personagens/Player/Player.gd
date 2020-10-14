extends Area2D

signal debug(Dtext) #TEST ONLY - For debuging the game;
signal sendto_add (instance) # Send to Main Scene a instance to be added
signal tutorial(type)
signal life_changed(life)
signal dead
signal pause (state)
signal free
signal reload_timer

#Player Atributes
var type = "Player"
var creator = "The Last"

var life = 3
var shot_range = 1.5
var shot_range_mult = 1
var maxlife = 3
var atk = 1

var delay_time = 0.5

var main = "bullet"
var weapon = ""
var shot_speed = 0
var shotis_able = false

var dead = true
var move_enabled = false
var speed = 300

#Instance
var Shot

#Player Processes

func _ready():
	$Initial_position.position = position
	
	Shot = load("res://Scenes/Tiros/round_mk1/round_mk1.tscn")
	shot_speed = 500
	weapon = "single"

func _process(delta):
	if Input.is_action_just_pressed("Tests"):
		create_shield()
	
	if $Sound_HIT.volume_db != GlobalVals.db_fx_value:
		$Sound_HIT.volume_db = GlobalVals.db_fx_value
	
	if $Sound_SHOOT.volume_db != GlobalVals.db_fx_value:
		$Sound_SHOOT.volume_db = GlobalVals.db_fx_value
	
	if $Sound_BOOM.volume_db != GlobalVals.db_fx_value:
		$Sound_BOOM.volume_db = GlobalVals.db_fx_value

func _input(event):

	if not dead and move_enabled:
		if event is InputEventScreenDrag:
			position = event.position
			position.x = clamp(position.x, 86, 454)
			position.y = clamp(position.y, 272, 970)
	

#Shot Creation Process

func create_shield():
	var shield = load("res://Scenes/Personagens/Player/Shield.tscn").instance()
	
	shield.position = position
	
	get_parent().add_child(shield)

func create_shot(posX, posY, angle):
	var shot = Shot.instance()
	
	shot.speed = shot_speed
	shot.creator = "Player"
	shot.yangle = -1
	shot.xangle += angle
	shot.position.y = posY
	shot.position.x = posX
	
	if weapon == "mega":
		shot.scale *= 3
		shot.atk = atk*3
	else:
		shot.atk = atk
	
	if (angle != 0):
		shot.rotation = 60/(angle*-10)
	
	shot.Srange = shot_range*shot_range_mult
	
	connect("pause", shot, "_pause")
	connect("free", shot, "_kill")
	
	emit_signal("sendto_add", shot)
	$Sound_SHOOT.play()
	shotis_able = false
	$ShotTimer.start()

func _on_Shot_Button_released():
	move_enabled = false

func _on_Shot_Button_pressed():
	if not move_enabled:
		move_enabled = true
	if shotis_able:
		
		$Shot_position.position = position
		
		match weapon:
			"single", "mega":
				shot_speed = 500
				shot_range = 2
				$ShotTimer.wait_time = delay_time
				#Delay 1
				create_shot($Shot_position.position.x, $Shot_position.position.y-64, 0)
			"triple":
				shot_speed = 300
				shot_range = 2
				$ShotTimer.wait_time = delay_time
				#Delay 2
				create_shot($Shot_position.position.x, $Shot_position.position.y-64, 0)
				
				if main == "laser":
					create_shot($Shot_position.position.x+32, $Shot_position.position.y-64, 0)
					create_shot($Shot_position.position.x-32, $Shot_position.position.y-64, 0)
				else:
					create_shot($Shot_position.position.x, $Shot_position.position.y-64, 0.5)
					create_shot($Shot_position.position.x, $Shot_position.position.y-64, -0.5)
					
			"quad":
				shot_speed = 300
				shot_range = 1.5
				$ShotTimer.wait_time = delay_time
				#Delay 3
				
				if main == "laser":
					
					var aux = $ShotTimer.wait_time
					
					create_shot($Shot_position.position.x+11, $Shot_position.position.y-64, 0)
					create_shot($Shot_position.position.x-11, $Shot_position.position.y-64, 0)
					$QuadLaserTimer.start()
					
				else:
					create_shot($Shot_position.position.x, $Shot_position.position.y-64, 0.2)
					create_shot($Shot_position.position.x, $Shot_position.position.y-64, -0.2)
					create_shot($Shot_position.position.x, $Shot_position.position.y-64, 0.7)
					create_shot($Shot_position.position.x, $Shot_position.position.y-64, -0.7)
				

func _on_ShotTimer_timeout():
	shotis_able = true

#Collision Processes

func _on_Player_area_entered(area):
	if "creator" in area and area.creator != "Player" and area.creator != "Ally":
		$Collision.set_deferred("disabled", true)
		life -= 1
		emit_signal("life_changed", life)
		
		if area.type == "Bullet":
			area.queue_free()
		elif area.type == "laser":
			area._disable_collision()
		
		if life <= 0:
	#		_restart() #TEST ONLY
			dead = true
			move_enabled = false
			$Sprite.play("EXPLODED")
			$Sound_BOOM.play()
			emit_signal("dead")
	#		
		else:
			$Sprite.play("DAMAGED")
			$Sound_HIT.play()

func _on_Sprite_animation_finished():
	if $Sprite.animation == "DAMAGED":
		$Collision.set_deferred("disabled", false)
		$Sprite.play("run")
		
	if $Sprite.animation == "EXPLODED":
		hide()
		$Sprite.play("run")

#Game General Processes

func _restart():
	$Collision.set_deferred("disabled", false)
	position = $Initial_position.position
	Shot = load("res://Scenes/Tiros/round_mk1/round_mk1.tscn")
	main = "bullet"
	maxlife = 3
	life = maxlife

func _start_bullet_countsown():
	$BulletTimer.start()

func _on_BulletTimer_timeout():
	weapon = "single"
	delay_time = 0.5

func _on_QuadLaserTimer_timeout():
	create_shot($Shot_position.position.x+32, $Shot_position.position.y-64, 0)
	create_shot($Shot_position.position.x-32, $Shot_position.position.y-64, 0)

#Game Options

func _on_Main_Scene_end_game():
	hide()
	dead = true
	move_enabled = false
	shotis_able = false
	$ShotTimer.stop()

func _on_Main_Scene_start_game():
	show()
	_restart()
	dead = false
	move_enabled = true
	shotis_able = true
	
	$ShotTimer.start()

func _on_Main_Scene_pause_game(state):
	if state:
		$ShotTimer.paused = true
		shotis_able = false
		move_enabled = false
		emit_signal("pause", true)
		
	else:
		$ShotTimer.paused = false
		shotis_able = true
		move_enabled = true
		emit_signal("pause", false)

func _on_capsule_collision(type):
	emit_signal("tutorial", type)
	match type:
		"TripleT": 
			if weapon != "triple":
				weapon = "triple"
				delay_time = 0.8
		"QuadT": 
			if weapon != "quad":
				weapon = "quad"
				delay_time = 1
		"Laser1": 
			if main != "laser":
				Shot = load("res://Scenes/Tiros/laser_mk1/laser_mk1.tscn")
				main = "laser"
				if weapon != "single":
					weapon = "single"
				delay_time = 0.5
		"BulletT": 
			if main != "bullet":
				Shot = load("res://Scenes/Tiros/round_mk1/round_mk1.tscn")
				main = "bullet"
				weapon = "single"
				delay_time = 0.5
		"MegaT":
			if weapon != "mega":
				weapon = "mega"
				delay_time = 0.5
		"LifeT":
			if life < maxlife and life > 0:
				life += 1
				get_parent().get_node("GUI")._reload_life(life)
		"LifeUpT":
			if maxlife < 10:
				maxlife += 1
				life = maxlife
				get_parent().get_node("GUI").get_node("LifeBar").max_value = life
				get_parent().get_node("GUI")._reload_life(life)
		"AtackUpT":
			if atk < 5:
				atk += 0.5
		"ShieldT":
			create_shield()

