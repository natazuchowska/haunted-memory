extends Node2D

var lie_count = 0
var questions_left = 4
var lies_container
var ask_question = false

var cursor_hand = preload("res://assets/UI/cursor_hand.png")
var cursor_normal = preload("res://assets/UI/cursor_normal.png")

func _ready():
	$AssistantSprite/AssistantButton.connect("pressed", interact_assistant)
	
	# manage cursor icon
	$AssistantSprite/AssistantButton.connect("mouse_entered", set_cursor)
	$AssistantSprite/AssistantButton.connect("mouse_exited", reset_cursor)
		
	lies_container = $HintBubble.get_children() # store all lies
	
	#lie_count = 0
	questions_left = %QuestionBar/VBoxContainer/HBoxContainer.get_children(false).size()
	
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

# cursor icon operations
func set_cursor():
	Input.set_custom_mouse_cursor(cursor_hand, Input.CURSOR_ARROW, Vector2(15.0, 15.0))
	
func reset_cursor():
		Input.set_custom_mouse_cursor(cursor_normal, Input.CURSOR_ARROW, Vector2(15.0, 15.0))
