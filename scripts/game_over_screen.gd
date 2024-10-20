extends Node2D

var cursor_hand = preload("res://assets/UI/cursor_hand.png")
var cursor_normal = preload("res://assets/UI/cursor_normal.png")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameMusic.play_music_menu()
	$CanvasLayer/RestartButton.connect("pressed", restart_game)
	$CanvasLayer/RestartButton.connect("mouse_entered", set_cursor)
	$CanvasLayer/RestartButton.connect("mouse_exited", reset_cursor)
	updateUI()
	
func restart_game():
	$ButtonClick.play()
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file(Global.LEVELS[Global.which_lvl])
	
	
	
func updateUI():
	$CanvasLayer/Label.text = tr("YOU_LOST")
	$CanvasLayer/RestartButton/Label.text = tr("TRY_AGAIN")
	
# cursor icon operations ===============================================================
func set_cursor():
	Input.set_custom_mouse_cursor(cursor_hand, Input.CURSOR_ARROW, Vector2(15.0, 15.0))
	
func reset_cursor():
	Input.set_custom_mouse_cursor(cursor_normal, Input.CURSOR_ARROW, Vector2(15.0, 15.0))
# =======================================================================================
