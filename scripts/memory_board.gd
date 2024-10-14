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

@onready var assistant: Node2D = %Assistant
@onready var hint_board: Node2D = $HintBoard
var hint_slots
var cards

var swapping_rows = false

func _ready():
	# load the normal texture
	normal_texture = $VBoxContainer/Row1/TextureButton.texture_normal
	
	children = v_box_container.get_children(false) # array of rows
	
	for x in children: # rows
		cards = x.get_children(false) # cards in a certain row
		for c in cards:
			c.connect("pressed", check_card.bind(c))
			win_count += 1
	win_count /= 2
	
	hint_slots = $HintBoard/VBoxContainer.get_children(false)
	for x in hint_slots:
		var card_hints = x.get_children(false)
		for h in card_hints:
			h.connect("pressed", show_hint.bind(h))
			
	wrong_count = 0
	how_many_good = 0
	
func check_card(c):
			
	if !assistant.ask_question:
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
			%Assistant/HintBubble/LIE.text = "YOU WIN!"
			await get_tree().create_timer(1.0).timeout
			Global.increase_level_num()
			if Global.get_level() < Global.get_levels_size(): # still some levels left
				get_tree().change_scene_to_file(Global.LEVELS[Global.get_level()])
			else: # game won so play cutscene
				get_tree().change_scene_to_file("res://scenes/cut_scene_end.tscn")
		
		for x in children:
			cards = x.get_children(false) # cards in a certain row
			for b in cards:
				if b!=card1 && b!=card2:
					b.mouse_filter = 0 # ignore input while animation is playing
			
	else:
		await get_tree().create_timer(0.5).timeout
		card1.texture_normal = normal_texture # hide back the card
		card2.texture_focused = normal_texture
		card2.texture_pressed = normal_texture
		
		
		wrong_count += 1
		%LifeBar.decrease_life()
		
		for x in children:
			cards = x.get_children(false) # cards in a certain row
			for b in cards:
				if b.texture_normal != b.texture_disabled:
					b.mouse_filter = 0 # ignore input while animation is playing
	
	
		if wrong_count >= 5:
			wrong_tries_count.text = ("YOU LOSE!!")
			get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")
		elif wrong_count == 3:
			wrong_tries_count.text = ("wrong tries count: " + str(wrong_count))
			
			for x in children: #block mouse input while swapping rows
				cards = x.get_children(false) # cards in a certain row
				for b in cards:
					if b.texture_normal != b.texture_disabled:
						b.mouse_filter = 2 # ignore input while animation is playing
			swap_rows()
			
			
		else:
			wrong_tries_count.text = ("wrong tries count: " + str(wrong_count))
	
		#for x in children:
			#cards = x.get_children(false) # cards in a certain row
			#for b in cards:
				#if b.texture_normal != b.texture_disabled:
					#b.mouse_filter = 0 # ignore input while animation is playing
	#
	
	card1.mouse_filter = 0 # enable input detection on first block again
		
func swap_rows():
	swapping_rows = true
	
	$AnimationPlayer.play("row_switch")
	$GhostSound.play()
	await get_tree().create_timer(2.0).timeout
	$AnimationPlayer.play("row2_switch")
	$GhostSound.play()
	await get_tree().create_timer(2.0).timeout
	
	$VBoxContainer.move_child(children[1], 0) # swap row 1 with row 2
	$HintBoard/VBoxContainer.move_child(hint_slots[1], 0) # swap hint rows accordingly
	
	$AnimationPlayer.play_backwards("row_switch")
	$GhostSound.play()
	await get_tree().create_timer(2.0).timeout
	$AnimationPlayer.play_backwards("row2_switch")
	$GhostSound.play()
	await get_tree().create_timer(2.0).timeout
	
	for x in children: #unlock memory blocks
		cards = x.get_children(false) # cards in a certain row
		for b in cards:
			if b.texture_normal!=b.texture_disabled:
				b.mouse_filter = 0 # ignore input while animation is playing
	
	swapping_rows = false
	
func show_hint(h):
	
	if assistant.questions_left > 0:
		print("showing hint!")
		#%Assistant/AssistantSprite.play("talk") # play assistant animation
		%Assistant/HintBubble/LIE.text = str(h.texture_disabled.get_path().get_file())
		%Assistant.questions_left -= 1
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
		
	hint_board.visible = false
	assistant.ask_question = false
	#await get_tree().create_timer(2.0).timeout
	#%Assistant/AssistantSprite.play("idle")
	#%Assistant/HintBubble/LIE.text = ""
	
	if assistant.questions_left == 0:
		%Assistant/HintBubble/LIE.text = "you ran out of questions!"
		
	print(h.texture_disabled.get_path().get_file())
	
	%Assistant/QuestionsLeftLabel.text = ("questions left: " + str(%Assistant.questions_left))
