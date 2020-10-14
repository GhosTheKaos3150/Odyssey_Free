extends Shot


func _ready():
	type = "Bomb"
	Srange = 0.8
	yangle = -1

func _process(delta):
	if speed > 0:
		speed -= 10

func _boom():
	$Bomb_Radius/Boob_Radius_Collision.set_deferred("disabled", false)
	$Audio.stream = load("res://Assets/Sons/Explosion.wav")
	$Audio.play()
	$Sprite.play("dead")

func _on_Sprite_animation_finished():
	if $Sprite.animation == "dead":
		hide()

func _on_Audio_finished():
	queue_free()
