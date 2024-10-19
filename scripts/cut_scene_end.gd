extends Control


func _ready():
	GameMusic.play_music_menu()
	
	$ExitButton.connect("pressed", go_back_to_main)
	$ExitButton.visible = false
	await get_tree().create_timer(5.0).timeout
	$ExitButton.visible = true # show the go back btn after 5 seconds
	await get_tree().create_timer(5.0).timeout
	$AnimationPlayer.play("light_blink")

func go_back_to_main():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
