extends Node2D

signal dead
signal _pause(state)
signal _free

var rec_prev = [0,0]

var end_runs = 0
var recharge_val = 0
var is_recharging = false

func _ready():
	randomize()
	
	connect("dead", get_parent(), "_on_Boss_dead")
	connect("_free", $Nave2D, "_kill")
	connect("_pause", $Nave2D, "_pause")
	
	$Canvas/TextureProgress.max_value = $Nave2D.life
	$Canvas/TextureProgress.value = $Nave2D.life

func _on_dead():
	var tank
	
	var sort = int(rand_range(1,10))
	
	if sort <= 5:
		tank = load("res://Scenes/Objetos/LifeUp_Tank.tscn").instance()
	else:
		tank = load("res://Scenes/Objetos/AtackUp_Tank.tscn").instance()
	
	$LifeSpawn/SpawnPoint.offset = randi()
	
	tank.get_node("Timer").wait_time = 10
	tank.position.x = $LifeSpawn/SpawnPoint.position.x
	tank.position.y = $LifeSpawn/SpawnPoint.position.y
	
	get_parent().add_child(tank)
	
	queue_free()

func _gen_life():
	var life = load("res://Scenes/Objetos/Life_Tank.tscn").instance()
	
	$LifeSpawn/SpawnPoint.offset = randi()
	
	life.get_node("Timer").wait_time = 5
	life.position.x = $LifeSpawn/SpawnPoint.position.x
	life.position.y = $LifeSpawn/SpawnPoint.position.y
	
	get_parent().add_child(life)

func _on_Nave2D_notify_recharge():
	if !is_recharging:
		_gen_life()
		recharge_val = 3
		is_recharging = true
		$Timer.start()

func _random_select():
	var rand = int(rand_range(1,6))
	
	match recharge_val:
		1:
			if rand != rec_prev[0] and rand != rec_prev[1]:
				match rand:
					1: $Anim1.play("L1_Atk")
					2: $Anim1.play("L2_Atk")
					3: $Anim1.play("L3_Atk")
					4: $Anim1.play("R1_Atk")
					5: $Anim1.play("R2_Atk")
					6: $Anim1.play("R3_Atk")
				rec_prev[0] = 0
				rec_prev[1] = 0
		2:
			if rand != rec_prev[0]:
				rec_prev[1] = rand
				match rand:
					1: $Anim2.play("L1_Atk")
					2: $Anim2.play("L2_Atk")
					3: $Anim2.play("L3_Atk")
					4: $Anim2.play("R1_Atk")
					5: $Anim2.play("R2_Atk")
					6: $Anim2.play("R3_Atk")
		3:
			rec_prev[0] = rand
			match rand:
				1: $Anim3.play("L1_Atk")
				2: $Anim3.play("L2_Atk")
				3: $Anim3.play("L3_Atk")
				4: $Anim3.play("R1_Atk")
				5: $Anim3.play("R2_Atk")
				6: $Anim3.play("R3_Atk")

func _on_Timer_timeout():
	if recharge_val > 0:
		recharge_val -= 1
		
		_random_select()
		
	else:
		is_recharging = false
		$Timer.stop()
	

func _on_End_Timer_timeout():
	
	$Nave2D/side_timer.stop()
	$Nave2D/front_timer.stop()
	$Nave2D/recharge_time.stop()
	$Timer.stop()
	
	if end_runs == 30:
		hide()
		_on_dead()
		emit_signal("dead")
		
	elif end_runs < 30:
		$Boom_pos.position.x = int(rand_range(10, 510))
		$Boom_pos.position.y = int(rand_range(210, 360))
		
		var boom = load("res://Scenes/Particulas/Boom_Object.tscn").instance()
		
		boom.position = $Boom_pos.position
		
		add_child(boom)
	
	end_runs += 1


func _on_Nave2D_notify_collision(area):

	$Canvas/TextureProgress.value = $Nave2D.life
	$Canvas/TextureProgress.value = $Nave2D.life

	if $Nave2D.life <= 0:
		if PGS.pgs != null and PGS.pgs.isSignedIn():
			PGS.pgs.unlockAchievement("CgkIqeCtvvUHEAIQCQ")
		$End_Timer.start()

func _kill():
	emit_signal("_free")
	queue_free()

func _pause(state):
	if state:
		$Timer.paused = true
	else:
		$Timer.paused = false
	
	emit_signal("_pause", state)
