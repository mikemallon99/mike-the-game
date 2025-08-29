extends StateMachine

func _ready():
	add_state("start_ui")
	add_state("player_picking")
	add_state("player_attacking")
	add_state("cog_picking")
	add_state("cog_attacking")
	add_state("player_win")
	add_state("cog_win")
	call_deferred("set_state", states.start_ui)

func _state_logic(delta):
	pass

func _get_transition(delta):
	match state:
		states.start_ui:
			if parent._start_ui_selected():
				return states.player_picking
		states.player_picking:
			if parent._player_gag_selected():
				return states.player_attacking
		states.player_attacking:
			if parent._player_done_attacking():
				if parent.cog_character.cur_hitpoints <= 0:
					return states.player_win
				else:
					return states.cog_picking
		states.cog_picking:
			if parent._cog_gag_selected():
				return states.cog_attacking
		states.cog_attacking:
			if parent._cog_done_attacking():
				if parent.player_character.cur_hitpoints <= 0:
					return states.cog_win
				else:
					return states.player_picking
		states.player_win:
			if parent._player_win_ui_done():
				return states.start_ui
		states.cog_win:
			if parent._cog_win_ui_done():
				return states.start_ui
	return null

func _enter_state(new_state, old_state):
	var cur_state_node = parent.get_node("BattleUI/CurState")
	cur_state_node.text = state_names[new_state]
	match new_state:
		states.start_ui:
			parent.show_start_ui()
		states.player_picking:
			parent._start_player_picking()
		states.player_attacking:
			parent._start_player_attack()
		states.cog_picking:
			parent._start_cog_picking()
		states.cog_attacking:
			parent._start_cog_attack()
		states.player_win:
			parent.hide_battle_ui()
			parent._start_win_ui()

func _exit_state(old_state, new_state):
	match old_state:
		states.start_ui:
			parent.hide_start_ui()
			parent.show_battle_ui()
		states.player_picking:
			parent.hide_picking_ui()
		states.player_win:
			parent._hide_player_win_ui()
