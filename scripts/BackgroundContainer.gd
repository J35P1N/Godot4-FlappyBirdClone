extends Node2D

func _process(_delta):
	if position.x <= -1600:
		position.x = 0
