extends Node2D


func _ready():
	updateUI()
	
	
func updateUI():
	$Assistant/QuestionsLeftLabel.text = tr("QUESTIONS_LEFT")
