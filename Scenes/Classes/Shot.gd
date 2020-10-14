extends Area2D

class_name Shot

#Shot Atributes
var type: String
var creator: String

var direction = Vector2()
var xangle: float
var yangle: float
var atk: float
var speed: int
var Srange: int

var move_enabled: bool

func _init():
	type = "Bullet"
	creator = ""
	
	xangle = 0
	yangle = 1
	speed = 200
	Srange = 3
	
	move_enabled = true

#Shot Processes

func _ready():
	direction.y += yangle
	direction.x += xangle
	$RangeTimer.wait_time = Srange
	$RangeTimer.start()

func _process(delta):
	if move_enabled:
		if direction.length() > 0:
			direction = direction.normalized() * speed
		
		position += direction * delta

func _pause(state):
	if state:
		move_enabled = false
	else:
		move_enabled = true

func _kill():
	queue_free()
