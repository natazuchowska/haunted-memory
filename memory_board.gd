extends Node2D

@onready var v_box_container: VBoxContainer = $VBoxContainer
var card_count = 1 # determine if it's the first or 2nd card seen

# store ref to cards to hide them if matching
var card1
var card2

var normal_texture
var texture_revealed # when card revealed

var btn1_pressed = false
var btn2_pressed = false

var win_count 
var how_many_good

func _ready():
	# load the normal texture
	normal_texture = $VBoxContainer/Row1/TextureButton.texture_normal
	win_count = 0
	how_many_good = 0
	
	var children = v_box_container.get_children(false) # array of buttons (cards)
	
	for x in children: # rows
		var cards = x.get_children(false) # cards in a certain row
		for c in cards:
			c.connect("pressed", check_card.bind(c))
			win_count += 1
	win_count /= 2
	
func check_card(c):
		if card_count == 1:
			check_card1(c)
		else:
			check_card2(c)
		
				
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
		
	await get_tree().create_timer(0.5).timeout
	btn1_pressed = false
	
func check_card2(c): # second card picked
	btn2_pressed = true
	card2 = c # card button
	print("checking card: 2")
	print(c.texture_pressed.get_path().get_file())
	texture_revealed = c.texture_pressed
	card_count -= 1
	
	btn2_pressed = false
	
	if card1.texture_pressed.get_path().get_file() == card2.texture_pressed.get_path().get_file():
		await get_tree().create_timer(0.5).timeout # wait 1 sec before hiding cards
		how_many_good += 1
		
		card1.texture_normal = card1.texture_disabled
		card1.texture_pressed = card1.texture_disabled
		card1.texture_hover = card1.texture_disabled
		card1.texture_focused = card1.texture_disabled
		#card1.interactive = false
		
		card2.texture_normal = card2.texture_disabled
		card2.texture_pressed = card2.texture_disabled
		card2.texture_hover = card2.texture_disabled
		card2.texture_focused = card2.texture_disabled
		#card2.interactive = false
		
		if how_many_good == win_count:
			print("YOU WIN!!!!!!")
	else:
		await get_tree().create_timer(0.5).timeout
		card1.texture_normal = normal_texture # hide back the card
		card2.texture_focused = normal_texture
		card2.texture_pressed = normal_texture
		
