extends Area2D

var life = 1
var creator = "Player"
var type = "Shield"

func _ready():
	print("shield created")

func _process(delta):
	position = get_parent().get_node("Player").position

func _on_Shield_area_entered(area):
	if area.creator != "Player" and area.creator != "Ally" and area.creator != "The Last":
		$Collision.set_deferred("disabled", true)

		if area.type != "Enemy" and area.type != "Player" and area.type != "STOPER":
			area.queue_free()

		life -= 1

		if life == 0:
			hide()
			$Audio.play()

func _on_Audio_finished():
	print("shield destroyed")
	queue_free()
