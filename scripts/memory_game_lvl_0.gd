extends Node2D


func _ready():
	updateUI()
	GameMusic.play_music_level()
	
	
func updateUI():
	$Assistant/QuestionsLeftLabel.text = tr("QUESTIONS_LEFT") + ":"
