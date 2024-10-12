extends TextureButton

signal show_name(texture_pressed.name)

func _ready():
	connect("pressed", do_when_pressed)

func do_when_pressed():
	pass
