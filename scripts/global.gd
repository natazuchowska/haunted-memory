extends Node

var which_lvl = 0
var LEVELS

var language
var languageID = 0

var music_slider_val = 0.75
var sfx_slider_val = 0.9


func _ready():
	# store all separate levels in an array
	LEVELS = ["res://scenes/memory_game_LVL0.tscn", "res://scenes/memory_game_LVL1.tscn", "res://scenes/memory_game_LVL2.tscn", "res://scenes/memory_game_LVL3.tscn"]
	
#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("pause_game"):
		#get_tree().paused = true
	
func increase_level_num():
	which_lvl += 1
	
func reset_game_lvl():
	which_lvl = 0
	
func get_level():
	return which_lvl
	
func get_levels_size():
	return LEVELS.size()
	
func set_language(index):
	if index == 0:
		language = "english"
		languageID = 0
	elif index == 1:
		language = "polish"
		languageID = 1
	elif index == 2:
		language = "french"
		languageID = 2
		
func get_language():
	return languageID
		
# geters and setters for music sliders to remember grabber positions
func set_music_slider_val(value: float):
	music_slider_val = value
	
func set_sfx_slider_val(value: float):
	sfx_slider_val = value

func get_music_slider_val():
	return music_slider_val
	
func get_sfx_slider_val():
	return sfx_slider_val
