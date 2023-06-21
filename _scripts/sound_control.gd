extends Control

var register_sound_node = [] #[sound_name, node]

func play_sound(sound_name : String, sfx_or_music = "sfx"):
	#Reset initial volume for music nodes
	$music_player1.volume_db = 0
	$music_player2.volume_db = 0
	
	#Get the correct sound file from the name passed
	var sound_file
	match sfx_or_music:
		"sfx":
			sound_file = load("res://_resources/_audio/sound_effects/" + sound_name + ".wav")
		"music":
			if sound_name != "lohweo_duel_scene" and sound_name != "lohweo_reward_scene":
				sound_file = load("res://_resources/_audio/music/" + sound_name + ".mp3")
		_:
			print("couldn't determine if Audio to be played is 'sfx' or 'music' ", sfx_or_music)
			return
	
	#For the 'duel_scene' the file has to be more specifically determined
	if sound_name == "lohweo_duel_scene":
		match PlayerData.scene_to_return_after_duel:
			"tournament_scene":
				sound_name = "lohweo_duel_tournament"
				if PlayerData.tournament_last_progression_saved == "tournament_rematch_end":
					sound_name = "lohweo_duel_tournament_rematch"
			"free_duel":
				sound_name = "lohweo_duel_free_pre"
		
		#Update the final sound_file path
		sound_file = load("res://_resources/_audio/music/" + sound_name + ".mp3")
	
	#For the 'reward_scene' the file changes between WIN and LOSE
	if sound_name == "lohweo_reward_scene":
		match get_node("../reward_scene").duel_winner:
			"player":
				sound_name = "lohweo_duel_win"
			_:
				sound_name = "lohweo_duel_lose"
		
		#Update the final sound_file path
		sound_file = load("res://_resources/_audio/music/" + sound_name + ".mp3")
	
	#Setup the correct files and names
	var sound_player_node = get_first_available_audio_player(sfx_or_music)
	sound_player_node.stream = sound_file
	
	#Adjust the volume
	adjust_sound_volume(PlayerData.game_volume)
	
	#Play the sound
	if sfx_or_music == "music":
		register_sound_node = [sound_name, sound_player_node]
	sound_player_node.play()

func bgm_fadeout():
	var transition_duration : float = 1.0
	var transition_type = 1 # TRANS_SINE
	
	#print(register_sound_node)
	var playing_node = register_sound_node[1]
	
	# tween music volume down to 0
	$fadeout_tween.interpolate_property(playing_node, "volume_db", playing_node.volume_db, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	$fadeout_tween.start()
	yield($fadeout_tween, "tween_completed")
	playing_node.stop()


func adjust_sound_volume(volume : float):
	var converted_volume : float = linear2db(volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), converted_volume)


func get_first_available_audio_player(sfx_or_music : String):
	var available_audio_player : Node = null
	
	for i in range(10):
		if get_node(sfx_or_music + "_player" + String(i+1)).is_playing():
			continue
		else:
			available_audio_player = get_node(sfx_or_music + "_player" + String(i+1))
			break
	
	#If somehow all the audio players are busy, force it on the first one anyway
	if available_audio_player == null:
		available_audio_player = get_node(sfx_or_music + "_player1")
	
	return available_audio_player
