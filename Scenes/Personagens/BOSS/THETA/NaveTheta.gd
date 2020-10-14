extends Area2D

signal pause(state)
signal free
signal notify_collision(area)
signal notify_recharge
var main_scene

var life = 100
var atk = 2
var Srange = 3
var type = "Enemy"
var creator = "Nostradamus Base"

var sort = true
var recharge = false
var recharge_val = 0
var can_shot = false

var laser = load("res://Scenes/Tiros/laser_mk1/laser_mk1.tscn")
var bulletA = load("res://Scenes/Tiros/round_mk1/round_mk1.tscn")
var bulletB = load("res://Scenes/Tiros/round_mk2/round_mk2.tscn")

func _ready():
	$AnimationPlayer.play("Boss")
	main_scene = get_parent().get_parent()

#Shot System

func create_shot(posX, posY, xangle, yangle, degrees, type):
	var shot = type.instance()
	
	shot.atk = atk
	shot.creator = "Enemy"
	shot.yangle = yangle
	shot.xangle = xangle
	shot.rotation_degrees = degrees
	shot.position.x = posX
	shot.position.y = posY
	shot.Srange = Srange
	
	connect("free", shot, "_kill")
	connect("pause", shot, "_pause")
	
	main_scene.add_child(shot)

func _shot_front():
	if !recharge and can_shot:
		sort = !sort
		recharge_val += 1
		
		$front_timer.wait_time = rand_range(1,2)
		
		if sort == true:
			create_shot($FRONT_A1.position.x, $FRONT_A1.position.y, 0, 1, 0, bulletA)
			create_shot($FRONT_A2.position.x, $FRONT_A2.position.y, 0, 1, 0, bulletA)
			
		else:
			create_shot($FRONT_B1.position.x, $FRONT_B1.position.y, 0, 1, 0, bulletB)
			create_shot($FRONT_B2.position.x, $FRONT_B2.position.y, 0, 1, 0, bulletB)

func _shot_side():
	if !recharge and can_shot:
		sort = !sort
		recharge_val += 1
		
		$side_timer.wait_time = rand_range(2,3)
		
		if sort == true:
			create_shot($SIDE_A1.position.x, $SIDE_A1.position.y, 1, 1, -45, laser)
			create_shot($SIDE_A2.position.x, $SIDE_A2.position.y, -1, 1, 45, laser)
			
		else:
			create_shot($SIDE_B1.position.x, $SIDE_B1.position.y, 1, 1, -45, laser)
			create_shot($SIDE_B2.position.x, $SIDE_B2.position.y, -1, 1, 45, laser)

func _on_recharge():
	if recharge and recharge_val <= 0:
		$recharge_time.wait_time = 0.5
		recharge = false
		
	elif recharge and recharge_val>0:
		recharge_val -= 1
		
	elif !recharge and recharge_val >= 10:
		$recharge_time.wait_time = 1
		recharge_val = 10
		recharge = true
		emit_signal("notify_recharge")
		

func _on_Nave2D_area_entered(area):
	if "creator" in area and (area.creator != "Enemy" and area.creator != "Ally"):
		$CollisionPolygon2D.set_deferred("disabled", true)
		
		if "atk" in area:
			life -= area.atk
		else:
			life -= 1
		
		if "type" in area and area.type != "Player" and area.type != "Enemy":
			area.queue_free()
	
	emit_signal("notify_collision", area)
	$Sprite.play("damage")

func _on_AnimationPlayer_animation_finished(anim_name):
	can_shot = !can_shot

func _on_Sprite_animation_finished():
	if $Sprite.animation == "damage":
		$CollisionPolygon2D.set_deferred("disabled", false)
		$Sprite.play("idle")

func _kill():
	emit_signal("free")
#	queue_free()

func _pause(state):
	
	if state:
		$side_timer.paused = true
		$front_timer.paused = true
		$recharge_time.paused = true
		
	else: 
		$side_timer.paused = false
		$front_timer.paused = false
		$recharge_time.paused = false
	
#	emit_signal("pause", state)
