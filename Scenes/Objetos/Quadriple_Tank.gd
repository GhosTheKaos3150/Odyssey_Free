extends Tank

func _ready():
	type = "QuadT"

#Signal Processes

func _on_TouchScreenButton_pressed():
	if !already_pressed:
		get_parent().get_node("Player")._start_bullet_countsown()
		
		$Timer.stop()
		emit_signal("notify_usage", type)
		$Sound_UP.play()
		already_pressed = true
		hide()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Sound_UP_finished():
	queue_free()

func _on_Sound_BLOWS_finished():
	queue_free()

#Collision Processes

func _on_Sprite_animation_finished():
	if $Sprite.animation == "EXPLODES":
		hide()

func _on_Timer_timeout():
	$Sprite.play("EXPLODES")
	$Sound_BLOWS.play()

func _on_Quad_Tank_area_entered(area):
	if area.type == "Player":
		connect("notify_collision", area, "_on_capsule_collision")
		emit_signal("notify_collision", type)
		
		get_parent().get_node("Player")._start_bullet_countsown()
		
		$Timer.stop()
		$Sound_UP.play()
		already_pressed = true
		hide()
