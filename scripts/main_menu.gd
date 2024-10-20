extends Control

var cursor_hand = preload("res://assets/UI/cursor_hand.png")
var cursor_normal = preload("res://assets/UI/cursor_normal.png")


func _ready():
	GameMusic.play_music_menu()
	Global.reset_game_lvl()
	
	$MenuContainer/VBoxContainer/StartButton.connect("pressed", start_game)
	$MenuContainer/VBoxContainer/SettingsButton.connect("pressed", go_to_settings)
	$MenuContainer/VBoxContainer/QuitButton.connect("pressed", quit_game)
	
	#$Label.text = tr("GAME_TITLE")
	$MenuContainer/VBoxContainer/StartButton/Label.text = tr("START")
	$MenuContainer/VBoxContainer/SettingsButton/Label.text = tr("SETTINGS")
	$MenuContainer/VBoxContainer/QuitButton/Label.text = tr("QUIT")
	
	# cursor icon changing
	$MenuContainer/VBoxContainer/StartButton.connect("mouse_entered", set_cursor)
	$MenuContainer/VBoxContainer/SettingsButton.connect("mouse_entered", set_cursor)
	$MenuContainer/VBoxContainer/QuitButton.connect("mouse_entered", set_cursor)
	
	$MenuContainer/VBoxContainer/StartButton.connect("mouse_exited", reset_cursor)
	$MenuContainer/VBoxContainer/SettingsButton.connect("mouse_exited", reset_cursor)
	$MenuContainer/VBoxContainer/QuitButton.connect("mouse_exited", reset_cursor)
	
	
func start_game():
	$ButtonClick.play()
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://scenes/cut_scene.tscn")
	
func go_to_settings():
	$ButtonClick.play()
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://scenes/settings_page.tscn")
	
func quit_game():
	$ButtonClick.play()
	get_tree().quit()
	
	
# cursor icon operations ===============================================================
func set_cursor():
	Input.set_custom_mouse_cursor(cursor_hand, Input.CURSOR_ARROW, Vector2(15.0, 15.0))
	
func reset_cursor():
	Input.set_custom_mouse_cursor(cursor_normal, Input.CURSOR_ARROW, Vector2(15.0, 15.0))
# =======================================================================================
