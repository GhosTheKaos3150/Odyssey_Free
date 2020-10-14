extends Node2D

func _ready():
	var coin = int(rand_range(0,5))
	
	if coin < 4:
		$Boom_Sound.set_deferred("autoplay", false)

func _on_AnimatedSprite_animation_finished():
	queue_free()
