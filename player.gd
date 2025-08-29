extends Area2D

@export var max_hitpoints = 15
@export var cur_hitpoints = 25

var gag_inventory = {
	"toonup": Array([0,0,0,0,0,0,0]),
	"trap": Array([0,0,0,0,0,0,0]),
	"lure": Array([0,0,0,0,0,0,0]),
	"sound": Array([0,0,0,0,0,0,0]),
	"throw": Array([5,0,0,0,0,0,0]),
	"squirt": Array([5,0,0,0,0,0,0]),
	"drop": Array([0,0,0,0,0,0,0]),
}

var gag_damage_values = {
	"toonup": Array([0,0,0,0,0,0,0]),
	"trap": Array([0,0,0,0,0,0,0]),
	"lure": Array([0,0,0,0,0,0,0]),
	"sound": Array([0,0,0,0,0,0,0]),
	"throw": Array([6,12,24,48,60,100,120]),
	"squirt": Array([4,8,15,28,36,80,120]),
	"drop": Array([0,0,0,0,0,0,0]),
}

func pick_attack(gag_type, gag_index):
	if gag_inventory[gag_type][gag_index] <= 0:
		printerr("Do not have requested gags")
		return -1
	gag_inventory[gag_type][gag_index] -= 1
	return gag_damage_values[gag_type][gag_index]
