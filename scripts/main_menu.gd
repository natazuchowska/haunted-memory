extends Control


func _ready():
	GameMusic.play_music_menu()
	
	$MenuContainer/VBoxContainer/StartButton.connect("pressed", start_game)
	$MenuContainer/VBoxContainer/SettingsButton.connect("pressed", go_to_settings)
	$MenuContainer/VBoxContainer/QuitButton.connect("pressed", quit_game)
	
	#$Label.text = tr("GAME_TITLE")
	$MenuContainer/VBoxContainer/StartButton/Label.text = tr("START")
	$MenuContainer/VBoxContainer/SettingsButton/Label.text = tr("SETTINGS")
	$MenuContainer/VBoxContainer/QuitButton/Label.text = tr("QUIT")
	
	
func start_game():
	$ButtonClick.play()
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://scenes/cut_scene_start.tscn")
	
func go_to_settings():
	$ButtonClick.play()
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://scenes/settings_page.tscn")
	
func quit_game():
	$ButtonClick.play()
	pass
