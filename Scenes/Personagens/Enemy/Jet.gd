extends Ship

func _ready():
	type = "Jet"
	speed = 1000

func _on_Jet_area_entered(area):
	if "type" in area:
		if area.type == "Player" or area.type == "Bullet" or area.type == "laser":
			$Collision.set_deferred("disabled", true)
			move_enabled = false
			emit_signal("killed")
			$AudioStreamPlayer.stream = load("res://Assets/Sons/Explosion.wav")
			$AudioStreamPlayer.play()
			$Sprite.play("dead")

func _on_AudioStreamPlayer_finished():
	if $AudioStreamPlayer.stream == load("res://Assets/Sons/Explosion.wav"):
		
		if PGS.pgs != null and PGS.pgs.isSignedIn():
			PGS.pgs.unlockAchievement("CgkIqeCtvvUHEAIQCw")
			PGS.pgs.incrementAchievement("CgkIqeCtvvUHEAIQDA", 1)
			PGS.pgs.incrementAchievement("CgkIqeCtvvUHEAIQDQ", 1)
		
		queue_free()

func _on_Sprite_animation_finished():
	if $Sprite.animation == "dead":
		hide()