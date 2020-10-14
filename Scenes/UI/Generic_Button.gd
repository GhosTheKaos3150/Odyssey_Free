extends Node2D

signal _pressed

func _ready():
	pass # Replace with function body.

func _on_TouchScreenButton_pressed():
	emit_signal("_pressed")
