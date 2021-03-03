extends Shot

#Signals
signal moved

func _ready():
	type = "laser"
	speed = 600

func _process(delta):
	if $Sound_Collision.volume_db !=  Global.db_fx_value:
		$Sound_Collision.volume_db = Global.db_fx_value

#Signal Processes

func _on_RangeTimer_timeout():
	$Collision.set_deferred("disabled", true)
	$AnimatedSprite.play("kill")

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "ignition":
		$AnimatedSprite.play("idle")
		$Collision.set_deferred("disabled", false)
		
		emit_signal("moved")
		
		move_enabled = true
	elif $AnimatedSprite.animation == "kill":
		queue_free()

#Collision Processes

func _on_Area2D_area_entered(area):
	if "type" in area and area.type == "laser" and creator != area.creator:
		$Collision.set_deferred("disabled", true)
		$Sound_Collision.play()
		direction.y = 0
		direction.x = 0
		position.x = 270
		position.y = 1
		hide()
		
	elif area.type == "Bullet" and creator != area.creator:
		area._on_laser_collision()

func _on_Sound_Collision_finished():
	queue_free()

#Game General Processes

func _disable_collision():
	$Collision.set_deferred("disabled", true)
