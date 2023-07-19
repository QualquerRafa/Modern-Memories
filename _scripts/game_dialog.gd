extends Node2D

signal dialog_scene_initialized

func _ready():
	#Animate the transition when starting this scene
	$scene_transitioner.entering_this_scene()
	$general_timer.start(0.8); yield($general_timer, "timeout")
	
	#When entering this scene, check which is the Dialog to load
	if PlayerData.recorded_dialogs.size() == 0:
		enter_new_dialog_from_fade("dlg_006", "no_fade")
	else:
		match PlayerData.recorded_dialogs[-1]: #based on the last recorded one, figure out the next to play
			_:
				var last_dlg_number = PlayerData.recorded_dialogs[-1].split("_")[1]
				var new_dlg_number = String(int(last_dlg_number) + 1).pad_zeros(3)
				enter_new_dialog_from_fade("dlg_" + new_dlg_number, "no_fade")

#---------------------------------------------------------------------------------------------------
# FUNCTIONALITY RELATED STUFF
#---------------------------------------------------------------------------------------------------
func load_dialog_timeline(timeline_name : String):
	var dialog_node = Dialogic.start(timeline_name)
	self.add_child(dialog_node)

func enter_new_dialog_from_fade(timeline_name : String, fade_or_not = "fade"):
	if fade_or_not == "fade":
		fade_screen("black")
		$general_timer.start(1.6); yield($general_timer, "timeout")
	
	#fake_box_moving_up()
	#yield(self, "dialog_scene_initialized")
	
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

#---- Player Name Stuff ----#
func player_input_name():
	#Load text in the correct language
	$additional_screen_elements/player_name_box/player_name_input.placeholder_text = GameLanguage.system.player_name[PlayerData.game_language]
	$additional_screen_elements/player_name_box/Button/done.text = GameLanguage.system.done[PlayerData.game_language]
	
	#Show the input box so the player can type
	$additional_screen_elements/player_name_box.show()
func _on_player_name_input_text_changed(_new_text):
	SoundControl.play_sound("poc_cursor")
func _on_Button_button_up():
	var inputed_name = $additional_screen_elements/player_name_box/player_name_input.text
	if inputed_name == "" or inputed_name == null:
		SoundControl.play_sound("poc_unable")
		return
	
	animate_button($additional_screen_elements/player_name_box/Button)
	PlayerData.player_name = inputed_name
	
	#Set the "Player Name" Dialogic variable as PlayerData.player_name
	Dialogic.set_variable("Player Name", PlayerData.player_name)
	
	$general_timer.start(0.2); yield($general_timer, "timeout")
	$additional_screen_elements/player_name_box.hide()
	load_dialog_timeline("dlg_002")

#---- Pop up Save stuff ----#
func pop_up_save():
	#Load text in the correct language
	$additional_screen_elements/pop_up_save/pop_up_text.text = GameLanguage.system.pop_up_save[PlayerData.game_language]
	$additional_screen_elements/pop_up_save/button_yes/label.text = GameLanguage.system.yes[PlayerData.game_language]
	$additional_screen_elements/pop_up_save/button_no/label.text = GameLanguage.system.no[PlayerData.game_language]
	
	#Show the pop up box
	$additional_screen_elements/pop_up_save.show()
	
func _on_button_yes_button_up():
	animate_button($additional_screen_elements/pop_up_save/button_yes)
	
	$additional_screen_elements/pop_up_save/save_logic.save_game()
	$general_timer.start(0.5); yield($general_timer, "timeout")
	$scene_transitioner.scene_transition("game_dialog")
	
	$additional_screen_elements/pop_up_save.hide()

func _on_button_no_button_up():
	animate_button($additional_screen_elements/pop_up_save/button_no)
	$scene_transitioner.scene_transition("game_dialog")
	$additional_screen_elements/pop_up_save.hide()

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
	
	print("fading in")
	$tween.interpolate_property(fade_color_node, "modulate", Color(1,1,1,0), Color(1,1,1,1), fade_time/2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$tween.start()
	yield($tween, "tween_completed")
	
	print("fading out")
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
	var list_of_specials = ["shop_out", "vs_darknite", "king_throne", "none"]
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
			var shake_time = 0.1
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







