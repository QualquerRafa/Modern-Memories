extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#Animate the transition when starting this scene
	$scene_transitioner.entering_this_scene()
	
	#Load the stored options
	load_options_file()
	
	#LOAD THE CORRECT INFO WHEN ENTERING THE SCENE
	$user_interface/top_info_box/window_title.text = GameLanguage.options_scene.scene_title[PlayerData.game_language]
	$CenterContainer/VBoxContainer/option_volume/window_title.text = GameLanguage.options_scene.volume_window[PlayerData.game_language]
	$CenterContainer/VBoxContainer/option_language/window_title.text = GameLanguage.options_scene.language_window[PlayerData.game_language]
	language_checkmark_update()
	$CenterContainer/VBoxContainer/option_others/window_title.text = GameLanguage.options_scene.others_window[PlayerData.game_language]
	$CenterContainer/VBoxContainer/option_others/auto_save.text = GameLanguage.options_scene.others_window_1[PlayerData.game_language]
	#$FocusShadow/game_credits.text = GameLanguage.options_scene.credits_soundtrack[PlayerData.game_language] + "\n" + GameLanguage.options_scene.credits_everything[PlayerData.game_language]
	$btn_credits/button_text.text = GameLanguage.options_scene.credits[PlayerData.game_language]
	
	$CenterContainer/VBoxContainer/option_volume/volume_percent_indicator.text = String(PlayerData.game_volume * 100) + "%"
	$CenterContainer/VBoxContainer/option_volume/scroller.value = PlayerData.game_volume * 10
	$CenterContainer/VBoxContainer/option_others/auto_save/option_check/checkmark.set_visible(PlayerData.game_autosave)

#---------------------------------------------------------------------------------------------------
func _on_scroller_value_changed(value):
	$CenterContainer/VBoxContainer/option_volume/volume_percent_indicator.text = String(value*10) + "%"
	SoundControl.adjust_sound_volume(value/10)
	PlayerData.game_volume = value/10

func _on_autosave_button_button_up():
	SoundControl.play_sound("poc_decide")
	if PlayerData.game_autosave == true:
		PlayerData.game_autosave = false
		$CenterContainer/VBoxContainer/option_others/auto_save/option_check/checkmark.hide()
	else:
		PlayerData.game_autosave = true
		$CenterContainer/VBoxContainer/option_others/auto_save/option_check/checkmark.show()

#---------------------------------------------------------------------------------------------------
func _on_english_button_button_up():
	SoundControl.play_sound("poc_decide")
	change_game_language("en")
func _on_portuguese_button_button_up():
	SoundControl.play_sound("poc_decide")
	change_game_language("pt")

func change_game_language(language : String):
	PlayerData.game_language = language
	language_checkmark_update()
	save_options_file()
	$scene_transitioner.scene_transition("options_scene")

func language_checkmark_update():
	if PlayerData.game_language == "en":
		$CenterContainer/VBoxContainer/option_language/english_language/option_check/checkmark.show()
		$CenterContainer/VBoxContainer/option_language/portuguese_language/option_check/checkmark.hide()
	elif PlayerData.game_language == "pt":
		$CenterContainer/VBoxContainer/option_language/portuguese_language/option_check/checkmark.show()
		$CenterContainer/VBoxContainer/option_language/english_language/option_check/checkmark.hide()

#---------------------------------------------------------------------------------------------------
func _on_back_button_button_up():
	SoundControl.play_sound("poc_decide")
	
	save_options_file()
	
	#Animate the button being clicked
	var small_scale = Vector2(0.9 , 0.9)
	var normal_scale = Vector2(1 , 1)
	
	$user_interface/UI_tween.interpolate_property($user_interface/back_button, "rect_scale", $user_interface/back_button.rect_scale, small_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$user_interface/UI_tween.start()
	yield($user_interface/UI_tween, "tween_completed")
	$user_interface/UI_tween.interpolate_property($user_interface/back_button, "rect_scale", $user_interface/back_button.rect_scale, normal_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$user_interface/UI_tween.start()
	
	$scene_transitioner.scene_transition("main_menu")

func save_options_file():
	var info_to_save = {
		"game_language" : PlayerData.game_language, #String
		"game_volume"   : PlayerData.game_volume, #float
		"game_autosave" : PlayerData.game_autosave, #bool
	}
	
	#Start the file to be written
	var save_file = File.new()
	save_file.open_encrypted_with_pass("user://gameoptions.save", File.WRITE, OS.get_unique_id()) #ENCRYPTED
	
	#Write info to save_file
	save_file.store_line(to_json(info_to_save)) #get 'info_to_save' dictionary and turn into JSON
	save_file.close()

func load_options_file():
	#Check if a saved file exists, if not, scape function
	var save_file = File.new()
	if not save_file.file_exists("user://gameoptions.save"):
		return
	
	#Load the file if one was found
	save_file.open_encrypted_with_pass("user://gameoptions.save", File.READ, OS.get_unique_id()) #ENCRYPTED
	
	var info_to_load = { } #start as empty dictionary and will be loaded key by key
	info_to_load = parse_json(save_file.get_as_text())
	
	#Load it safely. IF the save file has that information, load it. Good for future-proof with backwards compatibility
	var saved_info = [
		["game_language", "string"],
		["game_volume", "float"],
		["game_autosave", "bool"]
	]
	
	for i in range(saved_info.size()):
		if info_to_load.has(saved_info[i][0]):
			match saved_info[i][1]:
				"string":
					PlayerData[saved_info[i][0]] = String(info_to_load[saved_info[i][0]])
				"int":
					PlayerData[saved_info[i][0]] = int(info_to_load[saved_info[i][0]])
				"float":
					PlayerData[saved_info[i][0]] = float(info_to_load[saved_info[i][0]])
				"array":
					PlayerData[saved_info[i][0]] = Array(info_to_load[saved_info[i][0]])
				"dictionary":
					PlayerData[saved_info[i][0]] = Dictionary(info_to_load[saved_info[i][0]])
				"bool":
					PlayerData[saved_info[i][0]] = bool(info_to_load[saved_info[i][0]])
	
	return "sucess"

#---------------------------------------------------------------------------------------------------
#Credits Button
func _on_btn_credits_button_up():
	SoundControl.play_sound("poc_decide")
	
	#Animate the button being clicked
	var small_scale = Vector2(0.6 , 0.6)
	var normal_scale = Vector2(0.7 , 0.7)
	
	$btn_credits/tween.interpolate_property($btn_credits, "rect_scale", $btn_credits.rect_scale, small_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$btn_credits/tween.start()
	yield($btn_credits/tween, "tween_completed")
	$btn_credits/tween.interpolate_property($btn_credits, "rect_scale", $btn_credits.rect_scale, normal_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$btn_credits/tween.start()
	
	$scene_transitioner.scene_transition("credits_scene")
