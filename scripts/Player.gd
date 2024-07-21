extends RigidBody2D

var thrust : int = 1200

func _process(delta):
	if Input.is_action_just_pressed("Thrust"):
		apply_central_impulse(Vector2.UP * thrust)
		
