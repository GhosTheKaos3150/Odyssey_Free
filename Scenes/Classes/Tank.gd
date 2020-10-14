extends Node2D

class_name Tank

#Signals
signal notify_usage(type)
signal notify_collision(type)

#Tank Option
var type = "BulletT"
var creator = "Ally"
var direction = Vector2()
var speed = 100
var already_pressed = false

var move_enabled = true

#Scene Processes

func _ready():
	connect("notify_usage", get_parent(), "_on_Usage_item")

func _process(delta):
	
	if move_enabled:
		direction.y += 1
		
		if direction.length() > 0:
			direction = direction.normalized() * speed
		
		position += direction * delta

#General Game Processes

func _pause(state):
	if state:
		move_enabled = false
	else:
		move_enabled = true

func _kill():
	queue_free()
