extends AudioStreamPlayer2D

const level_music = preload("res://assets/audio/background_music.wav")
const menu_music = preload("res://assets/audio/704972__neartheatmoshphere__lounge-piano-loop.wav")

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return 
	
	stream = music 
	volume_db = volume
	
	if music == level_music:
		volume_db -= 5
		
	play()
	
func play_music_level():
	_play_music(level_music)
	
func play_music_menu():
	_play_music(menu_music)
	
func play_FX(stream: AudioStream, volume = 0.0):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream
	fx_player.name = "FX_PLAYER"
	fx_player.volume = volume
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	fx_player.queue_free()
	
	
	
