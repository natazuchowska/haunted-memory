extends Node

var which_lvl = 0
var LEVELS

var language


func _ready():
	# store all separate levels in an array
	LEVELS = ["res://scenes/memory_game_LVL0.tscn", "res://scenes/memory_game_LVL1.tscn", "res://scenes/memory_game_LVL2.tscn", "res://scenes/memory_game_LVL3.tscn"]
	
	
func increase_level_num():
	which_lvl += 1
	
func get_level():
	return which_lvl
	
func get_levels_size():
	return LEVELS.size()
	
func set_language(index):
	if index == 0:
		language = "english"
	elif index == 1:
		language = "polish"
	elif index == 2:
		language = "french"
