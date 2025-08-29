extends Node

var player_grid_coords = Vector2(0, 0)
var player_target_position: Vector2
var player : Area2D

var nicole_grid_coords = Vector2(5, 3)
var nicole : Area2D

# Game uses a coordinate system to move the player around
func get_screen_coords(grid_coords):
	return Vector2(grid_coords * 100)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $Player
	nicole = $Nicole
	nicole.position = get_screen_coords(nicole_grid_coords)

# Called every frame. 'delta' is the elapsed time since the previous frame.
var speed = 800
func _process(delta: float) -> void:
	player_target_position = get_screen_coords(player_grid_coords)
	player.position = player.position.move_toward(player_target_position, speed * delta)
	if player_grid_coords == nicole_grid_coords:
		Game._load_scene(Game.BATTLE_SCENE)

func _unhandled_input(event):
	# Physics
	if event.is_action_pressed("move_right"):
		player_grid_coords += Vector2(1, 0)
	if event.is_action_pressed("move_left"):
		player_grid_coords += Vector2(-1, 0)
	if event.is_action_pressed("move_down"):
		player_grid_coords += Vector2(0, 1)
	if event.is_action_pressed("move_up"):
		player_grid_coords += Vector2(0, -1)
