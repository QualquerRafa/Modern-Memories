extends Node2D

signal dialog_scene_initialized
var language_tag = ""

func _ready():
	#Animate the transition when starting this scene
	$scene_transitioner.entering_this_scene()
	$general_timer.start(0.8); yield($general_timer, "timeout")
	
	#For game languages other than Brazilian Portuguese, fetch the translated version of Dialogs from Dialogic. I hate how redundant that is...
	if PlayerData.game_language in ["en"]:
		language_tag = "_" + PlayerData.game_language
	
	#When entering this scene, check which is the Dialog to load
	if PlayerData.recorded_dialogs.size() == 0:
		enter_new_dialog_from_fade("dlg_001" + language_tag, "no_fade")
	else:
		match PlayerData.recorded_dialogs[-1]: #based on the last recorded one, figure out the next to play
			_:
				var last_dlg_number = PlayerData.recorded_dialogs[-1].split("_")[1]
				var new_dlg_number = String(int(last_dlg_number) + 1).pad_zeros(3)
				enter_new_dialog_from_fade("dlg_" + new_dlg_number + language_tag, "no_fade")

#---------------------------------------------------------------------------------------------------
# FUNCTIONALITY RELATED STUFF
#---------------------------------------------------------------------------------------------------
func load_dialog_timeline(timeline_name : String):
	var dialog_node = Dialogic.start(timeline_name)
	self.add_child(dialog_node)
	
	if Dialogic.get_variable("Player Name") != PlayerData.player_name:
		Dialogic.set_variable('Player Name', PlayerData.player_name)
	
	if PlayerData.game_language == "en":
		Dialogic.set_variable('grandpa_name_translation', 'Grandpa')
	
	for recorded in PlayerData.recorded_campaign_defeats:
		Dialogic.set_variable(recorded, 'true')
	
	#This is to prevent the dissonance if the player decides to close the game after act_016 and it wipes the temp variable set by dialogic
	if PlayerData.recorded_dialogs.size() == 0 or int(PlayerData.recorded_dialogs[-1].split("_")[1]) <= 16:
		if not PlayerData.recorded_campaign_defeats.has("campaign_defeat_YUGI"):
			Dialogic.set_variable('campaign_defeat_YUGI', 'false')
			Dialogic.set_variable('act_3_pick_local', 'Industrial Illusions')
		else:
			Dialogic.set_variable('campaign_defeat_YUGI', 'true')
			Dialogic.set_variable('act_3_pick_local', 'Kaiba Corp')

func enter_new_dialog_from_fade(timeline_name : String, fade_or_not = "fade"):
	if fade_or_not == "fade":
		fade_screen("black")
		$general_timer.start(1.6); yield($general_timer, "timeout")
	
	#Bug prevention. Add language tag only if the timeline_name doesnt have it already
	if language_tag != "" and timeline_name.find(language_tag) == -1:
		timeline_name = timeline_name + language_tag
	
	load_dialog_timeline(timeline_name)

func record_dialog_on_PlayerData(timeline_name):
	PlayerData.recorded_dialogs.append(timeline_name)

func change_background_music(music_file_name : String):
	SoundControl.bgm_fadeout() #stop whatever is current playing
	SoundControl.play_sound(music_file_name, "music") #play the new music file

func call_duel(opponent_name : String):
	PlayerData.going_to_duel = opponent_name
	PlayerData.scene_to_return_after_duel = "game_dialog"
	$scene_transitioner.scene_transition("deck_building")

func call_game_over():
	$scene_transitioner.scene_transition("game_over")

func clear_player_campaign_history():
	print("Player has finished the campaign, resetting the flags so it can be played from start again.")
	PlayerData.recorded_dialogs.clear()
	PlayerData.recorded_campaign_defeats.clear()
	
	#Dialogic variables, how I hate this piece of shit addon
	Dialogic.set_variable('act2_tea', 'false')
	Dialogic.set_variable('act2_tristan', 'false')
	Dialogic.set_variable('act2_bakura', 'false')
	Dialogic.set_variable('act2_duke', 'false')
	Dialogic.set_variable('act2_grandpa', 'false')

#---- Player Name Stuff ----#
func player_input_name():
	#Load text in the correct language
	$additional_screen_elements/player_name_box/player_name_input.placeholder_text = GameLanguage.system.player_name[PlayerData.game_language]
	$additional_screen_elements/player_name_box/Button/done.text = GameLanguage.system.done[PlayerData.game_language]
	
	#Show the input box so the player can type
	$additional_screen_elements/player_name_box.show()
func _on_player_name_input_text_changed(_new_text):
	SoundControl.play_sound("poc_cursor")

var name_click_once = false
func _on_Button_button_up():
	if name_click_once == true:
		return
	
	var inputed_name = $additional_screen_elements/player_name_box/player_name_input.text
	if inputed_name == "" or inputed_name == null:
		SoundControl.play_sound("poc_unable")
		return
	
	animate_button($additional_screen_elements/player_name_box/Button)
	PlayerData.player_name = inputed_name
	
	#Set the "Player Name" Dialogic variable as PlayerData.player_name
	Dialogic.set_variable("Player Name", PlayerData.player_name)
	name_click_once = true
	
	$general_timer.start(0.2); yield($general_timer, "timeout")
	$additional_screen_elements/player_name_box.hide()
	load_dialog_timeline("dlg_002" + language_tag)

#---- Pop up Save stuff ----#
func pop_up_save():
	#Load text in the correct language
	$additional_screen_elements/pop_up_save/pop_up_text.text = GameLanguage.system.pop_up_save[PlayerData.game_language]
	$additional_screen_elements/pop_up_save/button_yes/label.text = GameLanguage.system.yes[PlayerData.game_language]
	$additional_screen_elements/pop_up_save/button_no/label.text = GameLanguage.system.no[PlayerData.game_language]
	$additional_screen_elements/pop_up_save/button_return_to_title/label.text = GameLanguage.system.return_to_title[PlayerData.game_language]
	
	#Show the pop up box
	$additional_screen_elements/pop_up_save.show()

var save_click_once = false
func _on_button_yes_button_up():
	if save_click_once == true:
		return
	
	animate_button($additional_screen_elements/pop_up_save/button_yes)
	
	save_game()
	save_click_once = true
	$general_timer.start(0.5); yield($general_timer, "timeout")
	$scene_transitioner.scene_transition("game_dialog")
	
	$additional_screen_elements/pop_up_save.hide()

func _on_button_no_button_up():
	if save_click_once == true:
		return
	
	animate_button($additional_screen_elements/pop_up_save/button_no)
	save_click_once = true
	$scene_transitioner.scene_transition("game_dialog")
	$additional_screen_elements/pop_up_save.hide()

func _on_button_return_to_title_button_up():
	if save_click_once == true:
		return
	
	animate_button($additional_screen_elements/pop_up_save/button_return_to_title)
	
	save_game()
	save_click_once = true
	$general_timer.start(0.5); yield($general_timer, "timeout")
	$scene_transitioner.scene_transition("main_menu")

func save_game():
	$additional_screen_elements/pop_up_save/save_logic.save_game()

#---------------------------------------------------------------------------------------------------
# ANIMATION RELATED STUFF
#---------------------------------------------------------------------------------------------------
func fake_box_moving_up():
	#Initial setup
	var dialog_box_out = 840
	var dialog_box_in = 600
	$reference_dialog_box.position.y = dialog_box_out
	$reference_dialog_box.show()
	
	#Animate it moving up into the screen
	var timer = 0.5 #in seconds
	$tween.interpolate_property($reference_dialog_box, "position:y", dialog_box_out, dialog_box_in, timer, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$tween.start()
	yield($tween, "tween_completed")
	
	emit_signal("dialog_scene_initialized")
	$reference_dialog_box.hide()

func fade_screen(color): #'black' or 'white'
	#Initial setup
	var fade_color_node = get_node(color + "_overlay")
	fade_color_node.modulate = Color(1,1,1,0)
	fade_color_node.show()
	
	#Animation
	var fade_time = 1.5 #in seconds
	
	#print("fading in")
	$tween.interpolate_property(fade_color_node, "modulate", Color(1,1,1,0), Color(1,1,1,1), fade_time/2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$tween.start()
	yield($tween, "tween_completed")
	
	#print("fading out")
	$tween.interpolate_property(fade_color_node, "modulate", Color(1,1,1,1), Color(1,1,1,0), fade_time/2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$tween.start()
	yield($tween, "tween_completed")
	fade_color_node.hide()

func animate_button(button_path):
	SoundControl.play_sound("poc_decide")
	
	#Animate the button being clicked
	var small_scale = Vector2(0.9 , 0.9)
	var normal_scale = Vector2(1 , 1)
	
	var tweener = button_path.get_node("tween")
	
	tweener.interpolate_property(button_path, "rect_scale", button_path.rect_scale, small_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tweener.start()
	yield(tweener, "tween_completed")
	tweener.interpolate_property(button_path, "rect_scale", button_path.rect_scale, normal_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tweener.start()

func show_special_background(background_name : String, special_animation = "none"):
	var background_node = get_node("additional_screen_elements/special_backgrounds/" + background_name)
	
	#Show the correct BG and tercerize the animation so it doesn't stuck up Dialogic
	#$reference_dialog_box.show()
	background_node.show()
	animate_bg(background_node, special_animation)
	
	#Hide the other ones preemptively
	var list_of_specials = ["shop_out", "vs_darknite", "king_throne", "street_night", "none"]
	for bg in list_of_specials:
		if bg != background_name:
			get_node("additional_screen_elements/special_backgrounds/" + bg).hide()
	
func animate_bg(background_node, special_animation):
	var tweener = $additional_screen_elements/special_backgrounds/bg_tween
	
	match special_animation:
		"move_SW_NE":
			var initial_pos = Vector2(-128, 0)
			var final_pos = Vector2(0, -200)
			var movement_timer = 7
			
			tweener.interpolate_property(background_node, "position", initial_pos, final_pos, movement_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tweener.start()
			yield(tweener, "tween_completed")
		
		"move_up":
			if $additional_screen_elements/special_backgrounds/vs_darknite.is_visible():
				tweener.interpolate_property($additional_screen_elements/special_backgrounds/king_throne, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				tweener.start()
			
			var initial_pos = Vector2(0, -500)
			var final_pos = Vector2(0, -150)
			var movement_timer = 4
			
			tweener.interpolate_property(background_node, "position", initial_pos, final_pos, movement_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tweener.start()
			yield(tweener, "tween_completed")
		
		"shake": 
			var shake_time = 0.3
			var position1 = Vector2(-33, -45)
			var position2 = Vector2(-60, -45)
			var position3 = Vector2(-33, -15)
			var position4 = Vector2(0, -60)
			
			for _repetitions in range(33):
				if not background_node.is_visible():
					break
				
				tweener.interpolate_property(background_node, "position", position1, position2, shake_time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
				tweener.start()
				yield(tweener, "tween_completed")
				
				tweener.interpolate_property(background_node, "position", position2, position3, shake_time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
				tweener.start()
				yield(tweener, "tween_completed")
				
				tweener.interpolate_property(background_node, "position", position3, position4, shake_time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
				tweener.start()
				yield(tweener, "tween_completed")
				
				tweener.interpolate_property(background_node, "position", position4, position3, shake_time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
				tweener.start()
				yield(tweener, "tween_completed")
				
				tweener.interpolate_property(background_node, "position", position3, position2, shake_time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
				tweener.start()
				yield(tweener, "tween_completed")
				
				tweener.interpolate_property(background_node, "position", position2, position1, shake_time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
				tweener.start()
				yield(tweener, "tween_completed")
			
			#Hide the BG
			background_node.hide()










