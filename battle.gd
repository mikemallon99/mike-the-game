extends Node

@export var player_character : Area2D 
@export var cog_character : Area2D
var state_machine : StateMachine


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var state_machine = $StateMachine
	player_character = $Player
	cog_character = $Cog
	$BattleUI/PlayerHealth.text = str(player_character.cur_hitpoints)
	$BattleUI/CogHealth.text = str(cog_character.cur_hitpoints)
	$BattleUI/SquirtInventory.text = str(player_character.gag_inventory["squirt"][0])
	$BattleUI/ThrowInventory.text = str(player_character.gag_inventory["throw"][0])
	$BattleUI/Damage.hide()
	$BattleUI.hide()
	$StartUI.hide()
	$WinUI.hide()
	$AttackGraphics/Pie.hide()
	$AttackGraphics/Gear.hide()
	$AttackGraphics/Squirt/Flower.hide()
	$AttackGraphics/Squirt/Splash.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func display_damage(value):
	$BattleUI/Damage.text = "-" + str(value)
	$BattleUI/Damage.show()
	await get_tree().create_timer(1.0).timeout
	$BattleUI/Damage.hide()


# START UI STUFF
var _start_selected = false
func show_start_ui():
	$StartUI.show()

func hide_start_ui():
	$StartUI.hide()

func _start_button_pressed() -> void:
	_start_selected = true

func _start_ui_selected():
	if _start_selected:
		_start_selected = false
		return true
	return false

func show_battle_ui():
	$BattleUI.show()

func hide_battle_ui():
	$BattleUI.hide()

# PLAYER PICKING STUFF
var _player_gag_type : String
var _player_gag_index : int
var _player_gag_selected_bool : bool = false

func _select_gag(gag_type, gag_index):
	_player_gag_type = gag_type
	_player_gag_index = gag_index
	_player_gag_selected_bool = true

func _player_gag_selected():
	if _player_gag_selected_bool:
		_player_gag_selected_bool = false
		return true
	return false

func show_picking_ui():
	$BattleUI/ThrowButton.show()
	$BattleUI/ThrowInventory.show()
	$BattleUI/SquirtButton.show()
	$BattleUI/SquirtInventory.show()

func hide_picking_ui():
	$BattleUI/ThrowButton.hide()
	$BattleUI/ThrowInventory.hide()
	$BattleUI/SquirtButton.hide()
	$BattleUI/SquirtInventory.hide()

func _start_player_picking():
	_player_gag_selected_bool = false
	show_picking_ui()


# PLAYER ATTACK STUFF

var _player_done_attacking_bool = true
func _start_player_attack():
	var gag_type = _player_gag_type
	var gag_index = _player_gag_index
	_player_done_attacking_bool = false
	var damage = player_character.pick_attack(gag_type, 0)
	if damage == -1:
		return
	
	# TODO refactor this animation
	if gag_type == "squirt":
		$BattleUI/SquirtInventory.text = str(player_character.gag_inventory["squirt"][0])
		await squirt_flower_anim()
		_squirt_xp_acc += 1
	if gag_type == "throw":
		$BattleUI/ThrowInventory.text = str(player_character.gag_inventory["throw"][0])
		await attack_graphics($AttackGraphics/Pie, $AttackGraphics/PiePath/PieSpawn)
		_throw_xp_acc += 1
	
	cog_character.cur_hitpoints -= damage
	cog_character.cur_hitpoints = cog_character.cur_hitpoints if cog_character.cur_hitpoints > 0 else 0
	$BattleUI/CogHealth.text = str(cog_character.cur_hitpoints)
	display_damage(damage)
	await get_tree().create_timer(0.2).timeout
	_player_done_attacking_bool = true

func _player_done_attacking():
	return _player_done_attacking_bool

func squirt_flower_anim():
	var squirt_scale = Vector2(0.38, 0.38)
	$AttackGraphics/Squirt/Flower.scale = 0.0 * squirt_scale
	$AttackGraphics/Squirt/Flower.show()
	var i = 0
	while i < 20:
		var ratio = i/20.0
		$AttackGraphics/Squirt/Flower.scale = ratio * squirt_scale
		await get_tree().process_frame
		i += 1
	await attack_graphics($AttackGraphics/Squirt/Splash, $AttackGraphics/PiePath/PieSpawn)
	$AttackGraphics/Squirt/Flower.hide()


func attack_graphics(sprite, path_follow):
	path_follow.set_progress_ratio(0.0)
	sprite.position = path_follow.position
	sprite.show()
	var i = 0
	while i < 20:
		var ratio = i/20.0
		path_follow.set_progress_ratio(ratio)
		sprite.position = path_follow.position
		await get_tree().process_frame
		i += 1
	sprite.hide()

func _on_squirt_button_pressed() -> void:
	_select_gag("squirt", 0)

func _on_throw_button_pressed() -> void:
	_select_gag("throw", 0)


# COG PICKING STUFF
var _cog_gag_selected_bool = false
var _cog_damage = 0
func _start_cog_picking():
	var wait_time = randf() * 3 + 0.25
	await get_tree().create_timer(wait_time).timeout 
	_cog_damage = randi() % 4 + 1
	_cog_gag_selected_bool = true

func _cog_gag_selected():
	if _cog_gag_selected_bool:
		_cog_gag_selected_bool = false
		return true
	return false

# COG ATTACKING STUFF
var _cog_done_attacking_bool = true
func _start_cog_attack():
	_cog_done_attacking_bool = false
	player_character.cur_hitpoints -= _cog_damage
	player_character.cur_hitpoints = player_character.cur_hitpoints if player_character.cur_hitpoints > 0 else 0
	await attack_graphics($AttackGraphics/Gear, $AttackGraphics/GearPath/GearSpawn)
	display_damage(_cog_damage)
	$BattleUI/PlayerHealth.text = str(player_character.cur_hitpoints)
	await get_tree().create_timer(0.25).timeout
	_cog_done_attacking_bool = true

func _cog_done_attacking():
	return _cog_done_attacking_bool


# PLAYER WIN STUFF
var _throw_xp_acc = 0
var _max_throw_xp = 100
var _squirt_xp_acc = 0
var _max_squirt_xp = 100
var _player_win_ui_done_bool = false
func _start_win_ui():
	$WinUI/ThrowXP.text = "Throw XP: %d/%d" % [_throw_xp_acc, _max_throw_xp]
	$WinUI/SquirtXP.text = "Squirt XP: %d/%d" % [_squirt_xp_acc, _max_squirt_xp]
	$WinUI.show()

func _player_win_ui_done():
	if _player_win_ui_done_bool:
		_player_win_ui_done_bool = false
		return true
	return false

func _hide_player_win_ui():
	$WinUI.hide()

func _on_play_again_button_pressed() -> void:
	_player_win_ui_done_bool = true
