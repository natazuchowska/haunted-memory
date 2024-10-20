extends Control

var cursor_hand = preload("res://assets/UI/cursor_hand.png")
var cursor_normal = preload("res://assets/UI/cursor_normal.png")


func _ready():
	updateUI()
	GameMusic.play_music_menu()
	
	$ExitButton.connect("pressed", go_back_to_main)
	$ExitButton.visible = false
	await get_tree().create_timer(5.0).timeout
	$ExitButton.visible = true # show the go back btn after 5 seconds
	await get_tree().create_timer(5.0).timeout
	$AnimationPlayer.play("light_blink")
	
	$ExitButton.connect("mouse_entered", set_cursor)
	$ExitButton.connect("mouse_exited", reset_cursor)

func go_back_to_main():
	$ButtonClick.play()
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func updateUI():
	$TextTop.text = tr("WIN_MSG_TOP")
	$TextBottom.text = tr("WIN_MSG_BOTTOM")
	
	$ExitButton/Label.text = tr("EXIT")

# cursor icon operations ===============================================================
func set_cursor():
	Input.set_custom_mouse_cursor(cursor_hand, Input.CURSOR_ARROW, Vector2(15.0, 15.0))
	
func reset_cursor():
	Input.set_custom_mouse_cursor(cursor_normal, Input.CURSOR_ARROW, Vector2(15.0, 15.0))
# =======================================================================================
