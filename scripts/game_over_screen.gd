extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameMusic.play_music_menu()
	$CanvasLayer/RestartButton.connect("pressed", restart_game)
	
func restart_game():
	$ButtonClick.play()
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file(Global.LEVELS[Global.which_lvl])
	
	
