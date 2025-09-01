extends Node

var player : Area2D
var player_sprite : AnimatedSprite2D
var player_world : Vector2
var player_scale = Vector2(0.4, 0.4)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $Player
	last_direction = Vector2(0,0)
	player_sprite = $Player/AnimatedSprite2D
	player_sprite.animation = "idle_forward"
	
	bottom_right_point = $Background/BottomRight
	bottom_left_point = $Background/BottomLeft
	top_left_point = $Background/TopLeft
	top_right_point = $Background/TopRight
	
	player_world = Vector2(2, 6)

# Called every frame. 'delta' is the elapsed time since the previous frame.
var speed = 0.1
var last_direction : Vector2
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity += Vector2(1, 0)
	if Input.is_action_pressed("move_left"):
		velocity += Vector2(-1, 0)
	if Input.is_action_pressed("move_down"):
		velocity += Vector2(0, -1)
	if Input.is_action_pressed("move_up"):
		velocity += Vector2(0, 1)
	player_world += velocity * speed
	if player_world.x > bottom_right_point.world_coords.x:
		player_world.x = bottom_right_point.world_coords.x
	if player_world.x < 0:
		player_world.x = 0
	if player_world.y > top_right_point.world_coords.y:
		player_world.y = top_right_point.world_coords.y
	if player_world.y < 0:
		player_world.y = 0
	player.position = world_to_screen_coords(player_world)
	# Magic numbers, solved with y=mx+b
	player.scale = Vector2(1, 1) * (-0.014285*player_world.y + 0.4857)
	
	# Animation stuff
	if velocity:
		last_direction = velocity
	
	if velocity.x < 0:
		player_sprite.animation = "walk_left"
	elif velocity.x > 0:
		player_sprite.animation = "walk_right"
	elif velocity.y < 0:
		player_sprite.animation = "walk_forward"
	elif velocity.y > 0:
		player_sprite.animation = "walk_backward"
	else:
		if last_direction.x < 0:
			player_sprite.animation = "idle_left"
		elif last_direction.x > 0:
			player_sprite.animation = "idle_right"
		elif last_direction.y < 0:
			player_sprite.animation = "idle_forward"
		elif last_direction.y > 0:
			player_sprite.animation = "idle_backward"
		else:
			player_sprite.animation = "idle_forward"
	
	player_sprite.play()

# Need 4 corners
var bottom_left_point : Node2D
var bottom_right_point : Node2D
var top_left_point : Node2D
var top_right_point : Node2D

func world_to_screen_coords(player_world):
	# Get trapezoid lines
	# Abandoned this cuz I dont think we need line intersections
	#var m_bottom = (bottom_left_point.position.y - bottom_right_point.position.y)/(bottom_left_point.position.x - bottom_right_point.position.x)
	#var b_bottom = bottom_left_point.position.y - bottom_left_point.position.x * ((bottom_left_point.position.y - bottom_right_point.position.y)/(bottom_left_point.position.x - bottom_right_point.position.x))
	#var m_top = (top_left_point.position.y - top_right_point.position.y)/(top_left_point.position.x - top_right_point.position.x)
	#var b_top = top_left_point.position.y - top_left_point.position.x * ((top_left_point.position.y - top_right_point.position.y)/(top_left_point.position.x - top_right_point.position.x))
	#var m_left = (bottom_left_point.position.y - top_left_point.position.y)/(bottom_left_point.position.x - top_left_point.position.x)
	#var b_left = bottom_left_point.position.y - bottom_left_point.position.x * ((bottom_left_point.position.y - top_left_point.position.y)/(bottom_left_point.position.x - top_left_point.position.x))
	#var m_right = (top_right_point.position.y - bottom_right_point.position.y)/(top_right_point.position.x - bottom_right_point.position.x)
	#var b_right = top_right_point.position.y - top_right_point.position.x * ((top_right_point.position.y - bottom_right_point.position.y)/(top_right_point.position.x - bottom_right_point.position.x))
	
	# Get trapezoid vectors (only need top and bottom, can calc point with y percentage)
	var v_bottom = bottom_right_point.position - bottom_left_point.position
	var v_top = top_right_point.position - top_left_point.position
	#var v_left = top_left_point.position - bottom_left_point.position
	#var v_right = top_right_point.position - bottom_right_point.position
	
	# Get new lines
	# Get 2 points first then make line
	# Calc 2 points by getting percentage across world coords
	# Depends on world coords always being a rectangle
	var x_percent = (player_world.x - bottom_left_point.world_coords.x) / (bottom_right_point.world_coords.x - bottom_left_point.world_coords.x)
	var y_percent = (player_world.y - bottom_left_point.world_coords.y) / (top_left_point.world_coords.y - bottom_left_point.world_coords.y)
	
	var p_bottom = x_percent * v_bottom + bottom_left_point.position
	var p_top = x_percent * v_top + top_left_point.position
	var v_x = p_top - p_bottom
	var screen_point = y_percent * v_x + p_bottom
	
	return screen_point
