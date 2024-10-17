extends Node2D

@onready var v_box_container: VBoxContainer = $VBoxContainer
var card_count = 1 # determine if it's the first or 2nd card seen

@onready var wrong_tries_count: Label = $WrongTriesCount
var wrong_count = 0

# store ref to cards to hide them if matching
var card1
var card2

var normal_texture
var texture_revealed # when card revealed

var btn1_pressed = false
var btn2_pressed = false

var win_count = 0
var how_many_good = 0

var children # to store rows of cards
var level

@onready var assistant: Node2D = %Assistant
@onready var hint_board: Node2D = $HintBoard
var hint_slots
var cards

var swapping_rows = false

var tutorial_count = 0

var questions_left = 4
var mistakes_left = 100

var cursor_hand = preload("res://assets/UI/cursor_hand.png")
var cursor_normal = preload("res://assets/UI/cursor_normal.png")

func _ready():
	# load the normal texture
	normal_texture = $VBoxContainer/Row1/TextureButton.texture_normal
	
	# play opening scene animation
	%TransitionPlayer.play("start_scene")
	#$"../AnimationPlayer".play("start_scene")
	
	# check the current level
	level = Global.get_level()
	
	# set the number of questions and mistakes based on the level 
	questions_left = %QuestionBar/VBoxContainer/HBoxContainer.get_children(false).size() 
	mistakes_left = %LifeBar/VBoxContainer/HBoxContainer.get_children(false).size()
	
	print("questions for start: " + str(questions_left))
	print("mistakes for start: "+ str(mistakes_left))
	# ===========================================================
	
	children = v_box_container.get_children(false) # array of rows
	
	for x in children: # rows
		cards = x.get_children(false) # cards in a certain row
		for c in cards:
			c.connect("pressed", check_card.bind(c))
			# change cursor icon to hand when over memory blocks
			c.connect("mouse_entered", set_cursor)
			c.connect("mouse_exited", reset_cursor)
			win_count += 1
	win_count /= 2
	
	hint_slots = $HintBoard/VBoxContainer.get_children(false)
	for x in hint_slots:
		var card_hints = x.get_children(false)
		for h in card_hints:
			h.connect("pressed", show_hint.bind(h))
			# change cursor icon to hand when over memory blocks
			h.connect("mouse_entered", set_cursor)
			h.connect("mouse_exited", reset_cursor)
			
	wrong_count = 0
	how_many_good = 0
	
# cursor icon operations ===============================================================
func set_cursor():
	Input.set_custom_mouse_cursor(cursor_hand, Input.CURSOR_ARROW, Vector2(15.0, 15.0))
	
func reset_cursor():
	Input.set_custom_mouse_cursor(cursor_normal, Input.CURSOR_ARROW, Vector2(15.0, 15.0))
# =======================================================================================

func check_card(c):
			
	if !assistant.ask_question:
		# ONLY AT THE START -> TUTORIAL LEVEL ============
		if Global.get_level() == 0 && tutorial_count == 0:
			%BoardTutorial.visible = false
			%AssistantTutorial.visible = true
			tutorial_count += 1
		
		elif Global.get_level() == 0 && tutorial_count == 2:
			%GhostMessage.visible = false
			%GameTutorial.visible = true
			tutorial_count += 1
		# ================================================
			
		$BlockSound.play()
		if card_count == 1:
			check_card1(c)
		else:
			check_card2(c)
	else:
		pass
		
				
# methods to check if cards are matching
func check_card1(c): # first card picked
	
	btn1_pressed = true
	
	if card2 != null:
		card2.texture_pressed = texture_revealed
		card2.texture_focused = texture_revealed
		card2 = null
	
	card1 = c # card button
	print("checking card: 1")
	print(c.texture_pressed.get_path().get_file())
	c.texture_normal = c.texture_pressed # keep the card shown until card2 selected
	card_count += 1
	
	card1.mouse_filter = 2 # disable clicking this block twice
		
	await get_tree().create_timer(0.5).timeout
	btn1_pressed = false
	
func check_card2(c): # second card picked
	
	for x in children:
		cards = x.get_children(false) # cards in a certain row
		for b in cards:
			if b.texture_normal != b.texture_disabled:
				b.mouse_filter = 2 # ignore input while animation is playing
	
	
	btn2_pressed = true
	card2 = c # card button
	print("checking card: 2")
	print(c.texture_pressed.get_path().get_file())
	texture_revealed = c.texture_pressed
	card_count -= 1
	
	btn2_pressed = false
	
	# NEED FIXING THE FLIPPING BLOCKS BUG!!
	if card1.texture_pressed.get_path().get_file() == card2.texture_pressed.get_path().get_file() && card1!=card2:
		await get_tree().create_timer(0.5).timeout # wait 1 sec before hiding cards
		how_many_good += 1
		$GoodMatchSound.play()
		
		card1.texture_normal = card1.texture_disabled
		card1.texture_pressed = card1.texture_disabled
		card1.texture_hover = card1.texture_disabled
		card1.texture_focused = card1.texture_disabled
		#card1.interactive = false
		card1.mouse_filter = 2 # ignore further mouse inputs on this card
		
		card2.texture_normal = card2.texture_disabled
		card2.texture_pressed = card2.texture_disabled
		card2.texture_hover = card2.texture_disabled
		card2.texture_focused = card2.texture_disabled
		#card2.interactive = false
		card2.mouse_filter = 2 # ignore further mouse inputs on this card
		
		
		if how_many_good == win_count:
			# ONLY AT THE START -> TUTORIAL LEVEL ============
			if Global.get_level() == 0:
				%GameTutorial.visible = false
				%ClosingMessage.visible = true
			# ================================================
			
			#%Assistant/HintBubble/LIE.text = "YOU WIN!"
			%BoardCompleted.play() # play winning sound
			await get_tree().create_timer(1.0).timeout
			Global.increase_level_num()
			if Global.get_level() < Global.get_levels_size(): # still some levels left
				#%ChangeScene/AnimationPlayer.play("scene_end")
				await get_tree().create_timer(1.0).timeout
				get_tree().change_scene_to_file(Global.LEVELS[Global.get_level()])
			else: # game won so play cutscene
				get_tree().change_scene_to_file("res://scenes/cut_scene_end.tscn")
		
		for x in children:
			cards = x.get_children(false) # cards in a certain row
			for b in cards:
				# for all cards that are not the currently selected ones and not any already solved ones
				if b!=card1 && b!=card2 && b.texture_normal != b.texture_disabled:
					b.mouse_filter = 0 # allow input detection again
			
	else: # if chosen blocks do not match
		await get_tree().create_timer(0.5).timeout
		card1.texture_normal = normal_texture # hide back the card
		card2.texture_focused = normal_texture
		card2.texture_pressed = normal_texture
		
		wrong_count += 1
		mistakes_left -= 1 # take 1 life
		%LifeBar.decrease_life() # take 1 bubble away
		
		# allow mouse input on all unsolved blocks again
		for x in children:
			cards = x.get_children(false) # cards in a certain row
			for b in cards:
				# for all not yet solved cards
				if b.texture_normal != b.texture_disabled:
					b.mouse_filter = 0 
		
		# level 0 -> no swapping rows and no losing
		if Global.get_level() != 0:
			if mistakes_left <= 0:
				wrong_tries_count.text = ("YOU LOSE!!")
				get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")
			
			# LEVEL 1 SWAPPING BUTTONS -> after 3rd mistake
			elif wrong_count == 3 && level == 1:
				print("LEVEL: " + str(level))
				#wrong_tries_count.text = ("wrong tries count: " + str(wrong_count))
				
				for x in children: #block mouse input while swapping rows
					cards = x.get_children(false) # cards in a certain row
					for b in cards:
						if b.texture_normal != b.texture_disabled:
							b.mouse_filter = 2 # ignore input while animation is playing
				swap_rows()
			# LEVEL 2 SWAPPING ROWS -> after 4th mistake
			elif wrong_count == 4 && level == 2:
				print("LEVEL: " + str(level))
				#wrong_tries_count.text = ("wrong tries count: " + str(wrong_count))
				
				for x in children: #block mouse input while swapping rows
					cards = x.get_children(false) # cards in a certain row
					for b in cards:
						if b.texture_normal != b.texture_disabled:
							b.mouse_filter = 2 # ignore input while animation is playing
				swap_rows()
			# LEVEL 3 SWAPPING BLOCKS
			elif wrong_count == 4 && level == 3:
				print("LEVEL: " + str(level))
				#wrong_tries_count.text = ("wrong tries count: " + str(wrong_count))
				
				for x in children: #block mouse input while swapping rows
					cards = x.get_children(false) # cards in a certain row
					for b in cards:
						if b.texture_normal != b.texture_disabled:
							b.mouse_filter = 2 # ignore input while animation is playing
				swap_rows()
			# LEVEL 3 SWAPPING ROWS
			elif wrong_count == 7 && level == 3:
				print("LEVEL: " + str(level))
				#wrong_tries_count.text = ("wrong tries count: " + str(wrong_count))
				
				for x in children: #block mouse input while swapping rows
					cards = x.get_children(false) # cards in a certain row
					for b in cards:
						if b.texture_normal != b.texture_disabled:
							b.mouse_filter = 2 # ignore input while animation is playing
				swap_rows()
			else:
				#wrong_tries_count.text = ("wrong tries count: " + str(wrong_count))
				pass
		
			#for x in children:
				#cards = x.get_children(false) # cards in a certain row
				#for b in cards:
					#if b.texture_normal != b.texture_disabled:
						#b.mouse_filter = 0 # ignore input while animation is playing
		#
		
			# if cards didn't match
			card1.mouse_filter = 0 # enable input detection on first block again
			
func swap_rows():
	swapping_rows = true
	
	if Global.get_level() == 1:
		# switch in row 2: btns (1,2) with (3,4)
		print("reached LVL1 case of SWAP_ROWS()")
		
		$AnimationPlayer.play("blocks1_switch")
		$GhostSound.play()
		await get_tree().create_timer(2.0).timeout
		$AnimationPlayer.play("blocks2_switch")
		$GhostSound.play()
		await get_tree().create_timer(2.0).timeout
		
		var btns = children[1].get_children(false)
		
		$VBoxContainer/Row2.move_child(btns[1], 3) # move right btn to left
		$VBoxContainer/Row2.move_child(btns[0], 2) # move right btn to left
		
		hint_slots = $HintBoard/VBoxContainer.get_children(false)
		var hint_btns = hint_slots[0].get_children(false)
		# interchange the hint row ABOVE accordingly
		$HintBoard/VBoxContainer/Row1.move_child(hint_btns[1], 3) # move right btn to left
		$HintBoard/VBoxContainer/Row1.move_child(hint_btns[0], 2) # move right btn to left
		
		$AnimationPlayer.play_backwards("blocks1_switch")
		$GhostSound.play()
		await get_tree().create_timer(2.0).timeout
		$AnimationPlayer.play_backwards("blocks2_switch")
		$GhostSound.play()
		await get_tree().create_timer(2.0).timeout
		
	elif Global.get_level() == 2:
		# switch row 1 with row 2
		$AnimationPlayer.play("row_switch")
		$GhostSound.play()
		await get_tree().create_timer(2.0).timeout
		$AnimationPlayer.play("row2_switch")
		$GhostSound.play()
		await get_tree().create_timer(2.0).timeout
		
		$VBoxContainer.move_child(children[1], 0) # swap row 1 with row 2
		#$HintBoard/VBoxContainer.move_child(hint_slots[1], 0) # swap hint rows accordingly
		
		# interchange the hint rows BELOW accordingly
		$HintBoard/VBoxContainer.move_child(hint_slots[3], 2) # move right btn to left
		#$HintBoard/VBoxContainer.move_child(hint_btns[0], 2) # move right btn to left
		
		
		$AnimationPlayer.play_backwards("row_switch")
		$GhostSound.play()
		await get_tree().create_timer(2.0).timeout
		$AnimationPlayer.play_backwards("row2_switch")
		$GhostSound.play()
		await get_tree().create_timer(2.0).timeout
		
	elif Global.get_level() == 3:
		# switch row 1 with row 6
		$AnimationPlayer.play("row3_switch")
		$GhostSound.play()
		await get_tree().create_timer(2.0).timeout
		$AnimationPlayer.play("row4_switch")
		$GhostSound.play()
		await get_tree().create_timer(2.0).timeout
		
		$VBoxContainer.move_child(children[3], 2) # swap 2 middle rows
		
		# interchange the hint rows BELOW accordingly
		%HintBoard/VBoxContainer.move_child(hint_slots[3], 2) # swap the same hint rows
		
		$AnimationPlayer.play_backwards("row3_switch")
		$GhostSound.play()
		await get_tree().create_timer(2.0).timeout
		$AnimationPlayer.play_backwards("row4_switch")
		$GhostSound.play()
		await get_tree().create_timer(2.0).timeout
		
	
	
	for x in children: #unlock memory blocks
		cards = x.get_children(false) # cards in a certain row
		for b in cards:
			if b.texture_normal!=b.texture_disabled:
				b.mouse_filter = 0 # ignore input while animation is playing
	
	swapping_rows = false
	
func show_hint(h):
	
	# ONLY AT THE START -> TUTORIAL LEVEL ============
	if Global.get_level() == 0 && tutorial_count == 1:
		%AssistantTutorial.visible = false
		%GhostMessage.visible = true
		#%GameTutorial.visible = true
		tutorial_count += 1
	# ================================================
	
	%HintBoard.process_mode = 4 # disabled

	hint_slots = $HintBoard/VBoxContainer.get_children(false)
	for x in hint_slots:
		var card_hints = x.get_children(false)
		for hint in card_hints:
			hint.mouse_filter = 2
				
	
	if assistant.questions_left > 0:
		print("showing hint!")
		#%Assistant/AssistantSprite.play("talk") # play assistant animation
		#%Assistant/HintBubble/LIE.text = str(h.texture_disabled.get_path().get_file())
		
		questions_left -= 1
		%Assistant.questions_left = questions_left
		%HintDisplay.visible = true
		
		%HintDisplay.set_symbol(h.texture_disabled)
		
		%HintDisplay/HintContainer/AnimatedHint.play("show_bubble") # show the speech bubble
		%HintDisplay/GhostSound.play()
		await get_tree().create_timer(0.7).timeout
		#%Assistant/AssistantSprite.play("talk") # play assistant animation
		
		
		%HintDisplay/AnimationPlayer.play("show_symbol") # show the memo block symbol
		await get_tree().create_timer(1.1).timeout
		await get_tree().create_timer(3.4).timeout
		%HintDisplay/HintContainer/AnimatedHint.stop() # stop speech bubble anim
		%HintDisplay.visible = false
		
	for x in hint_slots:
		var card_hints = x.get_children(false)
		for hint in card_hints:
			hint.mouse_filter = 0
		
	%HintBoard.process_mode = 0 # process
	hint_board.visible = false
	assistant.ask_question = false
	#await get_tree().create_timer(2.0).timeout
	#%Assistant/AssistantSprite.play("idle")
	#%Assistant/HintBubble/LIE.text = ""
	
	if assistant.questions_left == 0:
		%Assistant/HintBubble/LIE.text = "you ran out of questions!"
		
	#print(h.texture_disabled.get_path().get_file())
	
	%Assistant/QuestionsLeftLabel.text = (tr("QUESTIONS_LEFT") + ":")  #+ ": " + str(%Assistant.questions_left))
	
	%QuestionBar.decrease_life()
