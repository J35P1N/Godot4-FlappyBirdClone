extends Node

@export var obstacle : PackedScene
@export var coin : PackedScene

var dynamic_object_speed : int = 700
var health_wane_speed : int = 3
var player_health : float = 100
var score : float
var spawned_object_position_x : int = 1700
var last_item_spawn_position : int = 1
var last_spawned_item_type : String


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
	else:
		game_over()
		
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

func _on_spawn_timer_timeout() -> void:	
	if last_spawned_item_type == "obstacle":
		_spawn_coin()	
	elif last_spawned_item_type == "coin" or last_spawned_item_type.is_empty():
		_spawn_obstacle()
		
func _spawn_obstacle():
	var random : int = randi() % 2
	var obstacle_instance : Area2D = obstacle.instantiate()		
	add_child(obstacle_instance)
	obstacle_instance.position.x = spawned_object_position_x
	if random == 0:
		obstacle_instance.position.y = 200
	if random == 1:
		obstacle_instance.position.y = 800
		obstacle_instance.scale.y *= -1
	
	obstacle_instance.body_entered.connect(_on_obstacle_collided)
	last_spawned_item_type = "obstacle"
	
func _spawn_coin():
	var random_coin_position : int = randi() % 3
	var coin_instance : Area2D = coin.instantiate()
	add_child(coin_instance)
	coin_instance.position.x = spawned_object_position_x
	coin_instance.position.y = 280 + random_coin_position * 200
	coin_instance.body_entered.connect(_on_coin_collided.bind(coin_instance))
	
	last_spawned_item_type = "coin"
	
func _on_obstacle_collided(body: Node2D) -> void:
	if body.is_in_group("Player"):
		game_over()
		

func _on_coin_collided(body : Node2D, coin_instance : Area2D) -> void:
	if body.is_in_group("Player"):
		player_health += 4
		coin_instance.get_node("AnimationPlayer").play("CoinCollected")
		$Player/CoinCollected.play()
		
		if player_health > 100:
			player_health = 100

func game_over() -> void:
	$Player/GameOver.play()
	$GameOver.show()
	get_tree().paused = true
		
