extends Control

var settings_volume : float = linear2db(PlayerData.game_volume)

#func _ready():
	#play_sound("poc_attack")

func play_sound(sound_name : String, sfx_or_music = "sfx"):
	#Get the correct sound file from the name passed
	var sound_file
	match sfx_or_music:
		"sfx":
			sound_file = load("res://_resources/_audio/sound_effects/" + sound_name + ".wav")
		"music":
			sound_file = load("res://_resources/_audio/music/" + sound_name + ".wav")
		"force": #used for scene transition what will play over everything
			sound_file = load("res://_resources/_audio/sound_effects/" + sound_name + ".wav")
		_:
			print("couldn't determine if Audio to be played is 'sfx' or 'music' ", sfx_or_music)
			return
	
	#Setup the correct files and names
	var sound_player_node = get_first_available_audio_player()
	sound_player_node.stream = sound_file
	
	#Adjust the volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), settings_volume)
	
	#Play the sound
	sound_player_node.play()

func get_first_available_audio_player():
	var available_audio_player : Node = null
	
	for i in range(10):
		if get_node("sfx_player" + String(i+1)).is_playing():
			continue
		else:
			available_audio_player = get_node("sfx_player" + String(i+1))
	
	#If somehow all the audio players are busy, force it on the first one anyway
	if available_audio_player == null:
		available_audio_player = get_node("sfx_player1")
	
	return available_audio_player
