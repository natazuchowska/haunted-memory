extends Control

var language_names = ["English", "Polski"]
var language_codes = ["en", "pl"]

var lang_id = -1

var cursor_hand = preload("res://assets/UI/cursor_hand.png")
var cursor_normal = preload("res://assets/UI/cursor_normal.png")


func _ready():
	updateUI()
	$Language/OptionButton.connect("item_selected", set_language)
	$GoBackButton.connect("pressed", return_to_menu)
	
	# cursor icon changes
	$Language/OptionButton.connect("mouse_entered", set_cursor)
	$Language/OptionButton.connect("mouse_exited", reset_cursor)
	$GoBackButton.connect("mouse_entered", set_cursor)
	$GoBackButton.connect("mouse_exited", reset_cursor)
	
	$Language/OptionButton.selected = Global.get_language()
	
	$Music/MusicSlider.value = Global.get_music_slider_val()
	$SFX/SFXSlider.value = Global.get_sfx_slider_val()
	
	if lang_id != -1:
		$Language/OptionButton.selected = lang_id
	
func set_language(index):
	print("setting the language:" + str(index))
	lang_id = index
	
	if index == 0: # ENGLISH
		TranslationServer.set_locale("en")
	elif index == 1: # POLISH
		TranslationServer.set_locale("pl")
	elif index == 2: # FRENCH
		TranslationServer.set_locale("fr")
		
	Global.set_language(index)
	
	updateUI()
		
func updateUI():
	$Language.text = tr("LANGUAGE")
	$Music.text = tr("MUSIC")
	$SFX.text = tr("SOUND_EFFECTS")
	$Language/OptionButton.set_item_text(0, tr("ENGLISH"))
	$Language/OptionButton.set_item_text(1, tr("POLISH"))
	$Language/OptionButton.set_item_text(2, tr("FRENCH"))
	
	$GoBackButton/Label.text = tr("GO_BACK")
	
func return_to_menu():
	$ButtonClick.play()
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

	
# cursor icon operations ===============================================================
func set_cursor():
	Input.set_custom_mouse_cursor(cursor_hand, Input.CURSOR_ARROW, Vector2(15.0, 15.0))
	
func reset_cursor():
	Input.set_custom_mouse_cursor(cursor_normal, Input.CURSOR_ARROW, Vector2(15.0, 15.0))
# =======================================================================================
