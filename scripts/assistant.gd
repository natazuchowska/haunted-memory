extends Node2D

var lie_count = 0
var questions_left = 4
var lies_container
var ask_question = false

func _ready():
	$AssistantSprite/AssistantButton.connect("pressed", interact_assistant)
	lies_container = $HintBubble.get_children() # store all lies
	
func interact_assistant():
	if questions_left > 0:
		ask_question = true
		print("can ask question now!")
	
		%HintBoard.visible = true # show hint slots
		
	#await get_tree().create_timer(2.0).timeout
	#%HintBoard.visible = false # hide hint slots
	
	#if questions_left - lie_count > 0:
		#lies_container[lie_count].visible = true
		#$AssistantSprite.play("talk")
		#await get_tree().create_timer(1.0).timeout
		#$AssistantSprite.play("idle")
		#lies_container[lie_count].visible = false
		#lie_count = (lie_count + 1)%lies_container.size()
	#else:
		#print("NO HINTS LEFT!")
	#
	#$QuestionsLeftLabel.text = ("questions left: " + str(questions_left - lie_count))
