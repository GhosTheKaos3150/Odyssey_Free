extends Ship

#Enemy Processes

func _ready():
	var random = int(rand_range(1, 100))
	
	if Global.dificuldade == "e":
		speed -= speed*0.1
		
	elif Global.dificuldade == "h":
		speed += speed*0.1
	
	Shot = load("res://Scenes/Tiros/laser_mk1/laser_mk1.tscn")
	
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
	
	if area.creator != "Enemy" and area.creator != "Nostradamus Base":
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

func _on_Delay_Timer_timeout():
	_return_move()

#Signal Processes

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Shot_Timer_timeout():
	if not dead:
		move_enabled = false
		create_shot(position.x + 24, position.y + 54)
		create_shot(position.x - 24, position.y + 54)
		$Sound_SHOT.play()
		$Delay_Timer.start()

#General Game Process

func _return_move():
	move_enabled = true
