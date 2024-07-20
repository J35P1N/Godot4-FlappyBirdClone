extends Node

var dynamic_object_speed : int = 700

func _process(delta):
	#position.x -= delta * dynamic_object_speed
	for dynamic_object in get_tree().get_nodes_in_group("DynamicObject"):
		dynamic_object.position.x -= delta * dynamic_object_speed
