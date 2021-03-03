extends Ship

var oscillator = 1
var const_rotation = 10

func _ready():
	speed = 500
	
	if Global.dificuldade == "e":
		$Oscilator_Timer.wait_time = 0.9
		
	elif Global.dificuldade == "h":
		$Oscilator_Timer.wait_time = 0.5
	
	clamp(position.x, 20, 520)
	
	if position.x < 540/2:
		const_rotation = -10
		oscillator = 1
	else:
		const_rotation = 10
		oscillator = -1
	
	direction.x = oscillator
	direction.y = 1

func _process(delta):
	if move_enabled and not dead:
		rotation_degrees += const_rotation
	
	if $AudioStreamPlayer2D.volume_db != Global.db_fx_value:
		$AudioStreamPlayer2D.volume_db = Global.db_fx_value

func _on_Area2D_area_entered(area):
	
	if area.type != "Enemy":
		
		$CollisionShape2D.set_deferred("disabled", true)
		if area.type == "Bullet":
			
			if "atk" in area:
				life -= area.atk
			else:
				life -= 1
			
			area.queue_free()
		elif area.type == "Player":
			life -= life
		
		if life <= 0:
			dead = true
			rotation_degrees = 0
			if PGS.pgs != null and PGS.pgs.isSignedIn():
				PGS.pgs.unlockAchievement("CgkIqeCtvvUHEAIQBQ") #Impossible
				PGS.pgs.incrementAchievement("CgkIqeCtvvUHEAIQBg", 1) #Impossible^2
				PGS.pgs.incrementAchievement("CgkIqeCtvvUHEAIQBw", 1) #Am I a Joke to You?
			$AudioStreamPlayer2D.stream = load("res://Assets/Sons/Explosion.wav")
			$AudioStreamPlayer2D.play()
			$Sprite.play("boom")
		else:
			$AudioStreamPlayer2D.stream = load("res://Assets/Sons/Hit_Hurt.wav")
			$AudioStreamPlayer2D.play()
			$Sprite.play("damage")

func _on_Sprite_animation_finished():
	if $Sprite.animation == "boom":
		create_item()
		hide()
		
	elif $Sprite.animation == "damage":
		$CollisionShape2D.set_deferred("disabled", false)
		$Sprite.play("idle")

func _on_Oscilator_Timer_timeout():
	oscillator *= -1
	direction.x = oscillator

func _on_AudioStreamPlayer2D_finished():
	if $AudioStreamPlayer2D.stream == load("res://Assets/Sons/Hit_Hurt.wav"):
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _pause(state):
	move_enabled = state
	
	if state:
		$Oscilator_Timer.paused = true
		move_enabled = false
		emit_signal("pause", true)
	else:
		$Oscilator_Timer.paused = false
		move_enabled = true
		emit_signal("pause", false)
	
