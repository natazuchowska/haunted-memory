extends Node2D

# SYMBOLS
var cat = preload("res://assets/hint symbols/hint_cat.png")
var eye = preload("res://assets/hint symbols/hint_eye.png")
var hanger = preload("res://assets/hint symbols/hint_hanger.png")
var pac_man = preload("res://assets/hint symbols/hint_pac_man.png")
var plus = preload("res://assets/hint symbols/hint_plus.png")
var rainbow = preload("res://assets/hint symbols/hint_rainbow.png")
var snail = preload("res://assets/hint symbols/hint_snail.png")

var SYMBOLS
var which_symbol

var HINT_ARRAY

func _ready():
	SYMBOLS = [cat, eye, hanger, pac_man, plus, rainbow, snail]

func set_symbol(symbol):
	$HintContainer/HintSymbol.texture = symbol
	
#func hints_LVL0():
	#HINT_ARRAY = [[snail, eye, cat],[eye, cat, snail]]
	#pass
	#
#func hints_LVL1():
	#pass
	#
#func hints_LVL2():
	#pass
	#
#func hints_LVL3():
	#pass
