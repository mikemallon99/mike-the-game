extends Node

var player : Area2D
var player_sprite : AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $Player
	last_direction = Vector2(0,0)
	player_sprite = $Player/AnimatedSprite2D
	player_sprite.animation = "idle_forward"

# Called every frame. 'delta' is the elapsed time since the previous frame.
var speed = 2
var last_direction : Vector2
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity += Vector2(1, 0)
	if Input.is_action_pressed("move_left"):
		velocity += Vector2(-1, 0)
	if Input.is_action_pressed("move_down"):
		velocity += Vector2(0, 1)
	if Input.is_action_pressed("move_up"):
		velocity += Vector2(0, -1)
	player.position += velocity * speed
	
	# Animation stuff
	if velocity:
		last_direction = velocity
	
	if velocity.x < 0:
		player_sprite.animation = "walk_left"
	elif velocity.x > 0:
		player_sprite.animation = "walk_right"
	elif velocity.y < 0:
		player_sprite.animation = "walk_backward"
	elif velocity.y > 0:
		player_sprite.animation = "walk_forward"
	else:
		if last_direction.x < 0:
			player_sprite.animation = "idle_left"
		elif last_direction.x > 0:
			player_sprite.animation = "idle_right"
		elif last_direction.y < 0:
			player_sprite.animation = "idle_backward"
		elif last_direction.y > 0:
			player_sprite.animation = "idle_forward"
		else:
			player_sprite.animation = "idle_forward"
	
	player_sprite.play()
