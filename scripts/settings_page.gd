extends Control

var language_names = ["English", "Polski"]
var language_codes = ["en", "pl"]

var lang_id = -1

func _ready():
	updateUI()
	$Language/OptionButton.connect("item_selected", set_language)
	$GoBackButton.connect("pressed", return_to_menu)
	
	$Language/OptionButton.selected = Global.get_language()
	
	$Music/MusicSlider.value = Global.get_music_slider_val()
	$SFX/SFXSlider.value = Global.get_sfx_slider_val()
	
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
	$ButtonClick.play()
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
