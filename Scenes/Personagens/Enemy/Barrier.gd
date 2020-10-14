extends Ship

var cannon_r = true
var barrier = "left"

var boom_ = 0
var kill_anim = false

func _ready():
	
	if GlobalVals.dificuldade == "e":
		speed = 80
		
	elif GlobalVals.dificuldade == "n":
		speed = 100
		
	else:
		speed = 120
	
	
	life = 3
	
	if position.x < 540/2:
		barrier = "left"
		position.x = 0
		
	else:
		barrier = "right"
		position.x = 540
	
	Shot = load("res://Scenes/Tiros/round_mk1/round_mk1.tscn")
	

func _process(delta):
	if $Sound_DEATH.volume_db != GlobalVals.db_fx_value:
		$Sound_DEATH.volume_db = GlobalVals.db_fx_value
	
#	#TEST ONLY
#	if position.y >= 512:
#		kill_anim = true

func _kill_anim():
	var efect = load("res://Scenes/Particulas/Boom_Object.tscn").instance()
	
	if barrier == "left":
		
		$sort_pos.position.x = int(rand_range(position.x, position.x + 200))
		$sort_pos.position.y = int(rand_range(position.y + 64, position.y - 64))
		
	else:
		
		$sort_pos.position.x = int(rand_range(position.x - 200, position.x))
		$sort_pos.position.y = int(rand_range(position.y + 64, position.y - 64))
	
	efect.position = $sort_pos.position
	
	get_parent().add_child(efect)
	boom_ += 1
	
	if boom_ >= 30:
		queue_free()


func _on_Barrier_area_entered(area):
	if area.creator != "Enemy" and area.creator != "":
		$Collision.set_deferred("disabled", true)
		
		if "atk" in area:
			life -= area.atk
		else:
			life -= 1
		
		area.queue_free()
		
		if (area.type != "Bullet" or life == 0):
			$Sound_DEATH.play()
			emit_signal("killed")
			kill_anim = true
			dead = true
		else:
			$Collision.set_deferred("disabled", false)
			$Sprite.play("damage")
#			$Sound_HIT.play()

func _on_Shot_Front_timeout():
	if !kill_anim:
		Shot = load("res://Scenes/Tiros/round_mk1/round_mk1.tscn")
		if cannon_r:
			if barrier == "right":
				create_shot(position.x-24, position.y + 80)
				
			elif barrier == "left":
				create_shot(position.x+24, position.y + 80)
				
			cannon_r = false
		else:
			if barrier == "right":
				create_shot(position.x-108, position.y + 80)
				
			elif barrier == "left":
				create_shot(position.x+108, position.y + 80)
			cannon_r = true

func _on_Shot_Side_timeout():
	if !kill_anim:
		Shot = load("res://Scenes/Tiros/laser_mk1/laser_mk1.tscn")
		if barrier == "right":
			create_sideShot(position.x-188, position.y + 10)
		elif barrier == "left":
			create_sideShot(position.x+188, position.y + 10)

func create_sideShot(posX, posY):
	var shot = Shot.instance()
	
	shot.atk = atk
	shot.creator = "Enemy"
	shot.yangle = 0.16
	
	if barrier == "left":
		shot.xangle = 1
	else:
		shot.xangle = -1
	
	shot.rotation_degrees = 90
	shot.position.x = posX
	shot.position.y = posY
	shot.Srange = Srange
	
	connect("pause", shot, "_pause")
	connect("free", shot, "_kill")
	
	get_parent().add_child(shot)

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()

func _on_Sound_DEATH_finished():
	queue_free()

func _on_Sprite_animation_finished():
	if $Sprite.animation == "damage":
		$Sprite.play("idle")
	elif $Sprite.animation == "boom":
		hide()

func _on_Timer_timeout():
	if kill_anim == true:
		move_enabled = false
		_kill_anim()

func _pause(state):
	move_enabled = state
	
	if state:
		$Shot_Front.paused = true
		$Shot_Side.paused = true
		move_enabled = false
		emit_signal("pause", true)
	else:
		$Shot_Front.paused = false
		$Shot_Side.paused = false
		move_enabled = true
		emit_signal("pause", false)
	
