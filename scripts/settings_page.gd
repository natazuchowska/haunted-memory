extends Control

var language_names = ["English", "Polski"]
var language_codes = ["en", "pl"]

var lang_id = -1

func _ready():
	updateUI()
	$Language/OptionButton.connect("item_selected", set_language)
	$GoBackButton.connect("pressed", return_to_menu)
	
	if lang_id != -1:
		$Language/OptionButton.selected = lang_id
	
func set_language(index):
	print("setting the language:" + str(index))
	lang_id = index
	
	if index == 0:
		TranslationServer.set_locale("en")
	elif index == 1:
		TranslationServer.set_locale("pl")
		
	Global.set_language(index)
	
	updateUI()
		
func updateUI():
	$Language.text = tr("LANGUAGE")
	$Music.text = tr("MUSIC")
	$SFX.text = tr("SOUND_EFFECTS")
	$Language/OptionButton.set_item_text(0, tr("ENGLISH"))
	$Language/OptionButton.set_item_text(1, tr("POLISH"))
	$Language/OptionButton.set_item_text(2, tr("FRENCH"))
	
func return_to_menu():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
