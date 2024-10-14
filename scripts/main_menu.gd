extends Control


func _ready():
	$VBoxContainer/StartButton.connect("pressed", start_game)
	$VBoxContainer/SettingsButton.connect("pressed", go_to_settings)
	$VBoxContainer/QuitButton.connect("pressed", quit_game)
	
	$Label.text = tr("GAME_TITLE")
	$VBoxContainer/StartButton/Label.text = tr("START")
	$VBoxContainer/SettingsButton/Label.text = tr("SETTINGS")
	$VBoxContainer/QuitButton/Label.text = tr("QUIT")
	
	
func start_game():
	get_tree().change_scene_to_file("res://scenes/cut_scene_start.tscn")
	
func go_to_settings():
	get_tree().change_scene_to_file("res://scenes/settings_page.tscn")
	
func quit_game():
	pass
