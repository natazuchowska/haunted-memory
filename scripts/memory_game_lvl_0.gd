extends Node2D


func _ready():
	updateUI()
	
	
	GameMusic.play_music_level()
	
	
func updateUI():
	$Assistant/QuestionsLeftLabel.text = tr("QUESTIONS_LEFT") + ":"
	
	if Global.get_level() != 0:
		$LivesLeft.text = tr("MISTAKES_LEFT") + ":"

	# only in tutorial level
	if Global.get_level() == 0:
		%BoardTutorial.text = tr("TUTORIAL_MSG_1")
		%AssistantTutorial.text = tr("TUTORIAL_MSG_2")
		%GhostMessage.text = tr("TUTORIAL_MSG_3")
		$GhostMessage/Label.text = tr("TUTORIAL_MSG_4")
		%GameTutorial.text = tr("TUTORIAL_MSG_5")
		%ClosingMessage.text = tr("TUTORIAL_MSG_6")
		
	if Global.get_level() == 1:
		$SceneTransition/TransitionBackground/LevelButton/Label.text = tr("LVL1")
	elif Global.get_level() == 2:
		$SceneTransition/TransitionBackground/LevelButton/Label.text = tr("LVL2")
	elif Global.get_level() == 3:
		$SceneTransition/TransitionBackground/LevelButton/Label.text = tr("LVL3")
	
