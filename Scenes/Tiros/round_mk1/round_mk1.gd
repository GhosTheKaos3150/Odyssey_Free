extends Shot

func _ready():
	speed = 500

func _process(delta):
	if $Sound_Collision.volume_db !=  GlobalVals.db_fx_value:
		$Sound_Collision.volume_db = GlobalVals.db_fx_value

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

#Collision Processes

func _on_round_mk1_area_entered(area):
	if "type" in area and area.type == "Bullet" and creator != area.creator:
		$Collision.set_deferred("disabled", true)
		$Sound_Collision.play()
		direction.y = 0
		direction.x = 0
		position.x = 270
		position.y = 1
		hide()
	

func _on_laser_collision():
	$Collision.set_deferred("disabled", true)
	$Sound_Collision.play()
	direction.y = 0
	direction.x = 0
	position.x = 270
	position.y = 1
	hide()

func _on_Sound_Collision_finished():
	queue_free()

#Signal Processes

func _on_RangeTimer_timeout():
	if move_enabled:
		$Collision.set_deferred("disabled", true)
		$Sprite.play("EXPLODED")
		direction.y = 0
		direction.x = 0
	else:
		$RangeTimer.start()

func _on_Sprite_animation_finished():
	if $Sprite.animation == "EXPLODED":
		queue_free()
