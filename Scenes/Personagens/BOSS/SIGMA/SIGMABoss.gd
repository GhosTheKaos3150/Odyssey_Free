extends Node2D

signal dead
signal pause(state)

var end_runs = 0

#Boss Processes:

func _ready():
	$AnimationPlayer.play("BossShip")
	
	connect("dead", get_parent(), "_on_Boss_dead")
	
	$Canvas/LifeBar.max_value = $Chefe.life
	$Canvas/LifeBar.value = $Chefe.life

func _process(delta):
	if $Chefe/Sound.volume_db != Global.db_fx_value:
		$Chefe/Sound.volume_db = Global.db_fx_value

func life_update(value):
	
	$Canvas/LifeBar.value = value
	
	if value <= 0:
		if PGS.pgs != null and PGS.pgs.isSignedIn():
			PGS.pgs.unlockAchievement("CgkIqeCtvvUHEAIQBA")
#			pass
		
		$Chefe/End_Timer.start()

#Signal Processes

func _on_Chefe_area_entered(area):
	if area.creator != "Enemy" and area.creator != "Ally":
		
		if area.type != "Player":
			area.queue_free()
		
		if "atk" in area:
			$Chefe.life -= area.atk
		else:
			$Chefe.life -= 1
		
		life_update($Chefe.life)
		
		$Chefe/AnimatedSprite.play("hit")

func _on_AnimatedSprite_animation_finished():
	if $Chefe/AnimatedSprite.animation == "hit":
		$Chefe/AnimatedSprite.play("idle")

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

func _on_Chefe_hipercannon():
	var life = load("res://Scenes/Objetos/Life_Tank.tscn").instance()
	
	$LifeSpawn/SpawnPoint.offset = randi()
	
	life.get_node("Timer").wait_time = 5
	life.position.x = $LifeSpawn/SpawnPoint.position.x
	life.position.y = $LifeSpawn/SpawnPoint.position.y
	
	get_parent().add_child(life)

func _pause(state):
	emit_signal("pause", state)

func _end_game():
	queue_free()

func _on_End_Timer_timeout():
	
	$Chefe/Hipercannon_Timer.stop()
	$Chefe/LV1_Cannons_Timer.stop()
	$Chefe/LV2_Cannons_Timer.stop()
	$Chefe/LV3_Cannons_Timer.stop()
	
	if end_runs == 30:
		hide()
		_on_dead()
		$Chefe/CollisionPolygon2D.set_deferred("disabled", true)
		emit_signal("dead")
	elif end_runs < 30:
		$Boom_pos.position.x = int(rand_range(10, 510))
		$Boom_pos.position.y = int(rand_range(210, 360))
		
		var boom = load("res://Scenes/Particulas/Boom_Object.tscn").instance()
		
		boom.position = $Boom_pos.position
		
		add_child(boom)
		$Chefe/Sound.stream = load("res://Assets/Sons/Explosion.wav")
		$Chefe/Sound.play()
	
	end_runs += 1

func _on_Sound_finished():
	if end_runs >= 30:
		queue_free()
