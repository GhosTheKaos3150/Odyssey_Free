extends Shot

var boom_enabled = true

func _ready():
	$RangeTimer.wait_time = 0.5
	$RangeTimer.start()
	speed = 500

func _process(delta):
	if $Sound_Collision.volume_db !=  GlobalVals.db_fx_value:
		$Sound_Collision.volume_db = GlobalVals.db_fx_value

#Shot Processes
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

#New Shot Process

func _new_Shot(angle):
	var Shot = load("res://Scenes/Tiros/round_mk1/round_mk1.tscn")
	
	var shot = Shot.instance()
	
	shot.atk = atk
	shot.creator = creator
	shot.yangle = 1
	shot.xangle = angle
	shot.scale.x = 1
	shot.scale.y = 1
	shot.position.x = position.x
	shot.position.y = position.y
	
	connect("pause", shot, "_pause")
	connect("free", shot, "_kill")
	
	get_parent().add_child(shot)

#Collision Processes

func _on_round_mk1_area_entered(area):
	if area.type == "Bullet" and creator != area.creator:
		$Collision.set_deferred("disabled", true)
		$Sound_Collision.play()
		boom_enabled = false
		direction.y = 0
		direction.x = 0
		position.x = 270
		position.y = 1
		hide()
	

func _on_laser_collision():
	$Collision.set_deferred("disabled", true)
	$Sound_Collision.play()
	boom_enabled = false
	direction.y = 0
	direction.x = 0
	position.x = 270
	position.y = 1
	hide()

func _on_Sound_Collision_finished():
	queue_free()

#Signal Processes

func _on_RangeTimer_timeout():
	if move_enabled and boom_enabled:
		$Collision.set_deferred("disabled", true)
		$Sprite.play("EXPLODED")
		direction.y = 0
		direction.x = 0
		_new_Shot(0)
		_new_Shot(0.3)
		_new_Shot(-0.3)
	else:
		$RangeTimer.start()

func _on_Sprite_animation_finished():
	if $Sprite.animation == "EXPLODED":
		queue_free()
