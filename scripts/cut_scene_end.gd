extends Control


func _ready():
	updateUI()
	GameMusic.play_music_menu()
	
	$ExitButton.connect("pressed", go_back_to_main)
	$ExitButton.visible = false
	await get_tree().create_timer(5.0).timeout
	$ExitButton.visible = true # show the go back btn after 5 seconds
	await get_tree().create_timer(5.0).timeout
	$AnimationPlayer.play("light_blink")

func go_back_to_main():
	$ButtonClick.play()
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func updateUI():
	$TextTop.text = tr("WIN_MSG_TOP")
	$TextBottom.text = tr("WIN_MSG_BOTTOM")
	
	$ExitButton/Label.text = tr("EXIT")
