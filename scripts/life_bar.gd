extends Node2D

var lives 
var life_ptr

func _ready():
	lives = $VBoxContainer/HBoxContainer.get_children(false) # all life buttons
	life_ptr = lives.size()-1

func decrease_life():
	if life_ptr >= 0:
		lives[life_ptr].texture_normal = lives[life_ptr].texture_disabled
		lives[life_ptr].texture_pressed = lives[life_ptr].texture_disabled
		lives[life_ptr].texture_hover = lives[life_ptr].texture_disabled
		lives[life_ptr].texture_focused = lives[life_ptr].texture_disabled
	
		life_ptr -= 1
	else:
		print("YOU LOST! NO LIVES LEFT")
	
