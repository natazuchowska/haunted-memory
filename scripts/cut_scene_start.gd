extends Node2D

func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/memory_game_LVL0.tscn") # start intruductory level
