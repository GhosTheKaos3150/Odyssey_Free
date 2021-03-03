extends Ship

#Enemy Processes

func _ready():
	
	var random = int(rand_range(1, 100))
	
	if Global.dificuldade == "e":
		speed -= speed*0.1
		
	elif Global.dificuldade == "h":
		speed += speed*0.1
	
	if (system_score >= 50 and random <= 35) or Global.dificuldade == "h":
		Shot = load("res://Scenes/Tiros/round_mk2/round_mk2.tscn")
		Srange = 0.5
	else:
		Shot = load("res://Scenes/Tiros/round_mk1/round_mk1.tscn")
	
	$LifeBar.max_value = life

func _process(delta):
	if $Sound_HIT.volume_db != Global.db_fx_value:
		$Sound_HIT.volume_db = Global.db_fx_value
	
	if $Sound_SHOT.volume_db != Global.db_fx_value:
		$Sound_SHOT.volume_db = Global.db_fx_value
	
	if $Sound_DEATH.volume_db != Global.db_fx_value:
		$Sound_DEATH.volume_db = Global.db_fx_value

#Collision Processes

func _on_Enemie_1_area_entered(area):
	if "creator" in area and area.creator != "Enemy":
		$Collision.set_deferred("disabled", true)
		
		if "atk" in area:
			life -= area.atk
			$LifeBar.value -= area.atk
		else:
			life -= 1
			$LifeBar.value -= 1
		
		if area.type == "Bullet":
			area.queue_free()
		
		if (area.type != "Bullet" or life <= 0):
			$Sprite.play("DEATH")
			$Sound_DEATH.play()
			emit_signal("killed")
			dead = true
		else:
			$Collision.set_deferred("disabled", false)
			$Sprite.play("DAMAGED")
			$Sound_HIT.play()

func _on_Sprite_animation_finished():
	if $Sprite.animation != "idle" and $Sprite.animation != "run":
		if $Sprite.animation == "DEATH":
			hide()
			$Sprite.stop()
			create_item()
		else:
			$Sprite.play("run")

func _on_Sound_DEATH_finished():
	queue_free()

#Signal Processes

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Shot_Timer_timeout():
	if not dead:
		create_shot(position.x, position.y + 64)
		$Sound_SHOT.play()
