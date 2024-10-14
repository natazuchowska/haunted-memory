extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/RestartButton.connect("pressed", restart_game)
	
func restart_game():
	get_tree().change_scene_to_file(Global.LEVELS[Global.which_lvl])
	
	
