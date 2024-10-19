extends Control

var texts
var text_index: int
var monkey_bubble
var ghost_bubble
var devil_bubble

func _ready():
	
	monkey_bubble = $SpeechBubbleContainer/MonkeyBubble
	ghost_bubble = $SpeechBubbleContainer/GhostBubble
	devil_bubble = $SpeechBubbleContainer/DevilBubble
	
	$FinalMessage.visible = false
	
	texts = [$SpeechBubbleContainer/MonkeyBubble/Label, 
			$SpeechBubbleContainer/MonkeyBubble/Label2,
			$SpeechBubbleContainer/MonkeyBubble/Label3,
			$SpeechBubbleContainer/GhostBubble/Label,
			$SpeechBubbleContainer/GhostBubble/Label2,
			$SpeechBubbleContainer/DevilBubble/Label,
			$SpeechBubbleContainer/DevilBubble/Label2,
			$SpeechBubbleContainer/DevilBubble/Label3,
			$SpeechBubbleContainer/MonkeyBubble/Label4,
			$SpeechBubbleContainer/MonkeyBubble/Label5,
			$SpeechBubbleContainer/MonkeyBubble/Label6,
			$SpeechBubbleContainer/MonkeyBubble/Label7,
			$SpeechBubbleContainer/MonkeyBubble/Label8,
			$SpeechBubbleContainer/MonkeyBubble/Label9,
			$SpeechBubbleContainer/GhostBubble/Label3,
			$SpeechBubbleContainer/GhostBubble/Label4,
			$SpeechBubbleContainer/MonkeyBubble/Label10]
		
	texts[0].visible = true
	text_index = 0
	
	monkey_bubble.visible = true
	ghost_bubble.visible = false
	devil_bubble.visible = false
#	will need updateUI() here later for different languages

	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("cutscene")
	
	await get_tree().create_timer(1.5).timeout
	$ClickLabel.visible = true # show label
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("skip_text"):
		if text_index == 0:
			hide_label()
		skip_thru_text()
	
func skip_thru_text():
	
	if text_index < texts.size()-1:
		texts[text_index].visible = false
		text_index += 1
		
		if text_index == 3:
			monkey_bubble.visible = false
			ghost_bubble.visible = true
		elif text_index == 5:
			ghost_bubble.visible = false
			devil_bubble.visible = true
		elif text_index == 8:
			devil_bubble.visible = false
			monkey_bubble.visible = true
		elif text_index == 14:
			monkey_bubble.visible = false
			ghost_bubble.visible = true
		elif text_index == 16:
			ghost_bubble.visible = false
			monkey_bubble.visible = true
			
		texts[text_index].visible = true
	else:
		# no more dialogue so start game
		monkey_bubble.visible = false # hide all bubbles
		$FinalMessage.visible = true
		$AnimationPlayer.play("show_final_message")
		await get_tree().create_timer(3.1).timeout
		
		await get_tree().create_timer(0.6).timeout
		GameMusic.lower_volume(1) # fade out the music
		await get_tree().create_timer(0.4).timeout
		
		get_tree().change_scene_to_file("res://scenes/memory_game_LVL0.tscn")

func hide_label():
	$AnimationPlayer.play("cutscene_nolabel")
	await get_tree().create_timer(2.5).timeout
	$ClickLabel.visible = false # hide click tutorial 
	$AnimationPlayer.play("cutscene")
