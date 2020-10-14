extends Area2D

signal _return

var life = 10
var broken = false
var creator = "Nostradamus Base"
var type = "STOPER"

func _on_Timer_timeout():
	emit_signal("_return")

func _killed():
	if life <= 0:
		broken = true
		$Audio.stream = load("res://Assets/Sons/Explosion.wav")
		$Audio.play()
		$CollisionShape2D.set_deferred("disabled", true)
		$Sprite.play("broken")

func _on_Tetha_Spikes_area_entered(area):
	if !broken:
		if "type" in area and area.type == "Bullet" or area.type == "laser":
			if "creator" in area and area.creator != "Enemy" and area.creator != "Nostradamus Base":
				
				$Sprite.play("damage")
				
				if "atk" in area:
					life -= area.atk
				else:
					life -= 1
				
				$Audio.play()
				area.queue_free()
	
	_killed()

func _on_Sprite_animation_finished():
	if $Sprite.animation == "damage":
		$Sprite.play("idle")
