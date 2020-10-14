extends Node2D

class_name Ship

#Enemy signals
signal killed
signal free
signal pause(state)

#Enemy Atributes:
var type: String
var creator: String

var system_score: int
var life: int
var atk: int
var speed: int
var Srange: int

var dead: bool
var move_enabled: bool
var direction = Vector2()

#Instances
var Shot

func _init():
	type = "Enemy"
	creator = "Nostradamus Base"
	
	life = 1
	atk = 1
	speed = 300
	Srange = 500
	
	dead = false
	move_enabled = true

func _ready():
	
	connect("killed", get_parent(), "_on_Enemy_killed")
	
	direction.x = 0
	direction.y = 1
	

func _process(delta):
	if move_enabled and not dead:
		position += (direction * speed) * delta

func create_shot(posX, posY):
	var shot = Shot.instance()
	
	shot.atk = atk
	shot.creator = "Enemy"
	shot.yangle = 1
	shot.xangle = 0
	shot.position.x = posX
	shot.position.y = posY
	shot.Srange = Srange
	
	connect("pause", shot, "_pause")
	connect("free", shot, "_kill")
	
	get_parent().add_child(shot)

func create_item():
	var prizeR = int(rand_range(0, 1000))
	
	if prizeR <= 150:
		var Item = load("res://Scenes/Objetos/Life_Tank.tscn")
		var item = Item.instance()
		
		item.position.x = position.x
		item.position.y = position.y
		
		connect("pause", item, "_pause")
		connect("free", item, "_kill")
		
		get_parent().add_child(item)
	
	if prizeR > 150 and prizeR <= 200:
		var Item = load("res://Scenes/Objetos/Bullet_Tank.tscn")
		var item = Item.instance()
		
		item.position.x = position.x
		item.position.y = position.y
		
		connect("pause", item, "_pause")
		connect("free", item, "_kill")
		
		get_parent().add_child(item)
	
	if prizeR > 200 and prizeR <= 250:
		var Item = load("res://Scenes/Objetos/Triple_Tank.tscn")
		var item = Item.instance()
		
		item.position.x = position.x
		item.position.y = position.y
		
		connect("pause", item, "_pause")
		connect("free", item, "_kill")
		
		get_parent().add_child(item)
	
	if prizeR > 250 and prizeR <= 300:
		var Item = load("res://Scenes/Objetos/Quadriple_Tank.tscn")
		var item = Item.instance()
		
		item.position.x = position.x
		item.position.y = position.y
		
		connect("pause", item, "_pause")
		connect("free", item, "_kill")
		
		get_parent().add_child(item)
	
	if prizeR > 300 and prizeR <= 335:
		var Item = load("res://Scenes/Objetos/Laser1_Tank.tscn")
		var item = Item.instance()
		
		item.position.x = position.x
		item.position.y = position.y
		
		connect("pause", item, "_pause")
		connect("free", item, "_kill")
		
		get_parent().add_child(item)
	
	if prizeR > 335 and prizeR <= 370:
		var Item = load("res://Scenes/Objetos/Mega_Tank.tscn")
		var item = Item.instance()
		
		item.position.x = position.x
		item.position.y = position.y
		
		connect("pause", item, "_pause")
		connect("free", item, "_kill")
		
		get_parent().add_child(item)
		
	
	if prizeR > 370 and prizeR <= 400:
		var Item = load("res://Scenes/Objetos/Shield_Tank.tscn")
		var item = Item.instance()
		
		item.position.x = position.x
		item.position.y = position.y
		
		connect("pause", item, "_pause")
		connect("free", item, "_kill")
		
		get_parent().add_child(item)

#General Game Process

func _pause(state):
	move_enabled = state
	
	if state:
		$Shot_Timer.paused = true
		move_enabled = false
		emit_signal("pause", true)
	else:
		$Shot_Timer.paused = false
		move_enabled = true
		emit_signal("pause", false)
	

func _kill():
	emit_signal("free")
	queue_free()
