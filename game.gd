extends Node

const OVERWORLD_SCENE := "res://overworld.tscn"
const BATTLE_SCENE    := "res://battle.tscn"

var _current_scene: Node

func _ready() -> void:
	pass

func _load_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)
