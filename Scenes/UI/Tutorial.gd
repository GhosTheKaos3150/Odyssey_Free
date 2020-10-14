extends Control

func _ready():
	$Anim_Moving.play("Anim_Moving")
	$Anim_item.play("Anim_Item")
	$Anim_shot.play("Anim_Shot")
	
	$Title.text = tr("_tutorial")
	$Moving_Ship.text = tr("_t_first")
	$Catching_Capsule2.text = tr("_t_second")
	$Shooting_Click.text = tr("_t_third")
	

func _on_Play_pressed():
	GlobalVals.first_time = false
	GlobalVals._save()
	get_tree().change_scene("res://Scenes/Cenas/Main Scene.tscn")
