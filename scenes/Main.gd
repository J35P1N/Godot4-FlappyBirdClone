extends Node

var dynamic_object_speed : int = 700
var health_wane_speed : int = 3
var player_health : float = 100
var score : float

func _process(delta):
	for dynamic_object in get_tree().get_nodes_in_group("DynamicObject"):
		dynamic_object.position.x -= delta * dynamic_object_speed
	
	calculate_player_health(delta)
	change_player_healthbar_color()
		
	score += delta
	var formatted_score : String = str(score)
	var decimal_index = formatted_score.find(".")
	$UI/Healthbar/ScoreLabel.text = formatted_score.left(decimal_index + 3)
		
func calculate_player_health(delta : float):
	if player_health > 0:
		player_health -= delta * health_wane_speed
		$UI/Healthbar.value = player_health
		
func change_player_healthbar_color() -> void:
	if player_health > 60:
		$UI/Healthbar.get("theme_override_styles/fill") \
			.bg_color = Color.PALE_GREEN
	elif player_health > 25 && player_health <= 60:
		$UI/Healthbar.get("theme_override_styles/fill") \
			.bg_color = Color.PALE_GOLDENROD
	else:
		$UI/Healthbar.get("theme_override_styles/fill") \
			.bg_color = Color.PALE_VIOLET_RED
