extends Node2D

var lie_count = 0
var questions_left = 4
var lies_container

func _ready():
	$AssistantSprite/AssistantButton.connect("pressed", show_lie)
	lies_container = $HintBubble.get_children() # store all lies
	
func show_lie():
	if questions_left - lie_count > 0:
		lies_container[lie_count].visible = true
		$AssistantSprite.play("talk")
		await get_tree().create_timer(1.0).timeout
		$AssistantSprite.play("idle")
		lies_container[lie_count].visible = false
		lie_count = (lie_count + 1)%lies_container.size()
	else:
		print("NO HINTS LEFT!")
	
	$QuestionsLeftLabel.text = ("questions left: " + str(questions_left - lie_count))
