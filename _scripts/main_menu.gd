extends Node2D

#Easy acess to game version text indicator
var GAME_VERSION_TEXT = "0.1.116"
var site_version = "k" #set by "http request"

func _ready():
	#Animate the transition when starting this scene
	$scene_transitioner.entering_this_scene()
	
	#Check for a saved options file to instantly load it
	var options_file = File.new()
	if options_file.file_exists("user://gameoptions.save"):
		auto_load_options_file()
	
	#Check for updates
	look_for_updates()
	
	#Properly load the text in the correct language
	load_text_in_correct_language()
	
	#Check for a savegame file to enable the load button or not
	var save_file = File.new()
	if save_file.file_exists("user://savegame.save"):
		$CenterContainer2/VBoxContainer/btn_load_game.modulate = Color(1,1,1,1)
	
	if PlayerData.game_loaded == false: #load the "New Game, Load Game, Options" menus
		$CenterContainer.hide()
		$big_logo.hide()
		$CenterContainer2.show()
		$small_logo.show()
	else:
		$CenterContainer2.hide()
		$small_logo.hide()
		$CenterContainer.show()
		$big_logo.show()
		$website_button.hide()

func auto_load_options_file():
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
	
	#NOW THAT THE INFORMATION WAS PROPERLY LOADED, UPDATE NECESSARY THINGS
	SoundControl.adjust_sound_volume(PlayerData.game_volume)

#---------------------------------------------------------------------------------------------------
func load_text_in_correct_language():
	#The initial main screen, with New Game, Load Game, Options and Version info
	$CenterContainer2/VBoxContainer/btn_new_game/button_text.text = GameLanguage.main_menu.new_game[PlayerData.game_language]
	$CenterContainer2/VBoxContainer/btn_load_game/button_text.text = GameLanguage.main_menu.load_game[PlayerData.game_language]
	$CenterContainer2/VBoxContainer/btn_options/button_text.text = GameLanguage.main_menu.options[PlayerData.game_language]
	$game_version.text = GameLanguage.main_menu.version[PlayerData.game_language] + GAME_VERSION_TEXT
	$save_load_overlay/loading_indicator.text = GameLanguage.system.loading[PlayerData.game_language] + " . . ."
	
	#The "second" main screen, with all the buttons for different scenes
	$CenterContainer/VBoxContainer/btn_campaign/button_text.text = GameLanguage.main_menu.campaign[PlayerData.game_language]
	$CenterContainer/VBoxContainer/btn_tournament/button_text.text = GameLanguage.main_menu.tournament[PlayerData.game_language]
	$CenterContainer/VBoxContainer/btn_free_duel/button_text.text = GameLanguage.main_menu.free_duel[PlayerData.game_language]
	$CenterContainer/VBoxContainer/btn_build_deck/button_text.text = GameLanguage.main_menu.build_deck[PlayerData.game_language]
	$CenterContainer/VBoxContainer/btn_password/button_text.text = GameLanguage.main_menu.card_shop[PlayerData.game_language]
	$CenterContainer/VBoxContainer/btn_save/button_text.text = GameLanguage.main_menu.save_game[PlayerData.game_language]
	
	#Save Game warning message
	$save_load_overlay/save_warning/export_window/export_description2.text = GameLanguage.main_menu.save_confirmation_warning[PlayerData.game_language]
	$save_load_overlay/save_warning/export_window/export_description3.text = GameLanguage.main_menu.save_path_indicator[PlayerData.game_language]
	$save_load_overlay/save_warning/button_close/label.text = GameLanguage.system.confirm[PlayerData.game_language]

#---------------------------------------------------------------------------------------------------
func look_for_updates():
	var _request_return = $game_version/HTTPRequest.request("https://permitted-memories.github.io/gameversion.html")

func _on_HTTPRequest_request_completed(result, _response_code, _headers, body):
	if result == 0: #RESULT_SUCCESS
		var site_version_return = body.get_string_from_utf8().trim_suffix("\n")
		var game_version_string = $game_version.text.split(" ")[1]
		
		if site_version_return != game_version_string:
			$game_version/version_update_warning.text = GameLanguage.main_menu.update[PlayerData.game_language] + String(site_version_return)
			$game_version/version_update_warning.show()
		else:
			print("Game Version matched the current version fetched from the Site: ", site_version_return)
			$game_version/version_update_warning.hide()
		
	else:
		print("Request wasn't completed, result enum: ", result)
		$game_version/version_update_warning.text = GameLanguage.main_menu.unable_to_check_for_updates[PlayerData.game_language]
		$game_version/version_update_warning.show()

#---------------------------------------------------------------------------------------------------
func save_game():
	#Show the overlay warning, the button there actually calls the logic lol
	$save_load_overlay/save_warning.show()
	$save_load_overlay.show()
var already_confirmed = false
func _on_export_close_button_up():
	if already_confirmed:
		return
	
	already_confirmed = true
	animate_button($save_load_overlay/save_warning/button_close)
	
	#Call for the Save Game function
	$save_load_logic.save_game()
	$timer.start(0.5); yield($timer, "timeout")
	
	$save_load_overlay/save_warning.hide()
	$save_load_overlay.hide()
	already_confirmed = false
#This is the darken background that will "cancel" the saving process
func _on_Button_button_up():
	if $save_load_overlay/save_warning.is_visible():
		$save_load_overlay/save_warning.hide()
		$save_load_overlay.hide()

func load_game():
	$save_load_overlay/tween.interpolate_property($save_load_overlay/darker_screen, "modulate", Color(1,1,1,0), Color(1,1,1,0.8), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$save_load_overlay.show()
	
	#Call for the Load Game function
	$save_load_logic.load_game()
	$timer.start(0.6); yield($timer, "timeout") #give it some time
	PlayerData.game_loaded = true
	
	$save_load_overlay/tween.interpolate_property($save_load_overlay/darker_screen, "modulate", Color(1,1,1,0.8), Color(1,1,1,0), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	separation_of_boxes()
	$timer.start(0.6); yield($timer, "timeout") #give it some time
	$save_load_overlay.hide()

func separation_of_boxes():
	var offset = 1000
	var timer = 0.5
	
	#Move out the on screen buttons 
	for i in range($CenterContainer2.get_node("VBoxContainer").get_child_count()):
		var the_node = $CenterContainer2.get_node("VBoxContainer").get_child(i)
		if i%2 == 0:
			$button_tweener.interpolate_property(the_node, "rect_position:x", the_node.rect_position.x, the_node.rect_position.x + offset, timer, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			$button_tweener.start()
		else:
			$button_tweener.interpolate_property(the_node, "rect_position:x", the_node.rect_position.x, the_node.rect_position.x - offset, timer, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			$button_tweener.start()
	$animation_tweener.interpolate_property($small_logo, "modulate", Color(1,1,1,1), Color(1,1,1, 0), timer, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$animation_tweener.interpolate_property($website_button, "modulate", Color(1,1,1,1), Color(1,1,1, 0), timer, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$animation_tweener.start()
	$timer.start(timer); yield($timer, "timeout")
	$CenterContainer2.hide()
	
	#Now move in the stuff from the "second page" of the menu
	$big_logo.modulate = Color(1,1,1,0)
	$big_logo.show()
	$animation_tweener.interpolate_property($big_logo, "modulate", Color(1,1,1,0), Color(0.5,0.5,0.5, 0.5), timer, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$animation_tweener.start()
	
	for i in range($CenterContainer.get_node("VBoxContainer").get_child_count()):
		var the_node = $CenterContainer.get_node("VBoxContainer").get_child(i)
		if i%2 == 0:
			the_node.rect_position.x += offset
			$button_tweener.interpolate_property(the_node, "rect_position:x", the_node.rect_position.x, the_node.rect_position.x - offset, timer, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			$button_tweener.start()
		else:
			the_node.rect_position.x -= offset
			$button_tweener.interpolate_property(the_node, "rect_position:x", the_node.rect_position.x, the_node.rect_position.x + offset, timer, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			$button_tweener.start()
	$timer.start(timer*0.55); yield($timer, "timeout")
	$CenterContainer.show()

#---------------------------------------------------------------------------------------------------
#CLICKING THE BUTTONS
func _on_website_button_button_up():
	animate_button($website_button)
	var _open_website = OS.shell_open("https://permitted-memories.github.io/")
func _on_force_website_button_up():
	animate_button($force_update_overlay/force_website)
	var _open_website = OS.shell_open("https://permitted-memories.github.io/")

func _on_btn_new_game_button_up():
	if PlayerData.game_loaded == true:
		return
	
	animate_button($CenterContainer2/VBoxContainer/btn_new_game)
	
	#Create a new Player Deck
	if PlayerData.player_deck.size() == 0:
		var _DEBUG_initialize_Player_Deck : Array = PlayerData.create_player_deck()
	PlayerData.game_loaded = true #even though this is not a proper load, a New Game sets this variable as well
	
	#In the future, this function should throw the player directly to the Campaign first scene. For now, to the next menu page
	separation_of_boxes()

func _on_btn_load_game_button_up():
	if PlayerData.game_loaded == true:
		return
	
	if $CenterContainer2/VBoxContainer/btn_load_game.modulate == Color(1,1,1,1):
		animate_button($CenterContainer2/VBoxContainer/btn_load_game)
		load_game() #will emit the signal 'game_loaded' once everything is properly loaded

func _on_btn_options_button_up():
	if PlayerData.game_loaded == true:
		return
	
	animate_button($CenterContainer2/VBoxContainer/btn_options)
	change_scene("options_scene")

func _on_btn_campaign_button_up():
	animate_button($CenterContainer/VBoxContainer/btn_campaign)
	change_scene("game_dialog")
func _on_btn_tournament_button_up():
	animate_button($CenterContainer/VBoxContainer/btn_tournament)
	change_scene("tournament_scene")
func _on_btn_free_duel_button_up():
	animate_button($CenterContainer/VBoxContainer/btn_free_duel)
	change_scene("free_duel")
func _on_btn_build_deck_button_up():
	animate_button($CenterContainer/VBoxContainer/btn_build_deck)
	change_scene("deck_building")
func _on_btn_library_button_up():
	pass # Replace with function body.
func _on_btn_password_button_up():
	animate_button($CenterContainer/VBoxContainer/btn_password)
	change_scene("card_shop")
func _on_btn_save_button_up():
	animate_button($CenterContainer/VBoxContainer/btn_save)
	save_game()

func animate_button(node : Node):
	SoundControl.play_sound("poc_decide")
	
	#Animate the button being clicked
	var small_scale = Vector2(0.9 , 0.9)
	var normal_scale = Vector2(1 , 1)
	
	if node == $save_load_overlay/save_warning/button_close/export_close:
		small_scale = Vector2(1.1, 0.9)
		normal_scale = Vector2(1.3, 1)
	
	$button_tweener.interpolate_property(node, "rect_scale", node.rect_scale, small_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$button_tweener.start()
	yield($button_tweener, "tween_completed")
	$button_tweener.interpolate_property(node, "rect_scale", node.rect_scale, normal_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$button_tweener.start()

func change_scene(scene_to_go_to : String):
	$scene_transitioner.scene_transition(scene_to_go_to)


#---------------------------------------------------------------------------------------------------
#HOVERING OVER BUTTONS
func _on_btn_campaign_mouse_entered():
	hovering_over_button($CenterContainer/VBoxContainer/btn_campaign)
func _on_btn_tournament_mouse_entered():
	hovering_over_button($CenterContainer/VBoxContainer/btn_tournament)
func _on_btn_free_duel_mouse_entered():
	hovering_over_button($CenterContainer/VBoxContainer/btn_free_duel)
func _on_btn_build_deck_mouse_entered():
	hovering_over_button($CenterContainer/VBoxContainer/btn_build_deck)
func _on_btn_library_mouse_entered():
	hovering_over_button($CenterContainer/VBoxContainer/btn_library)
func _on_btn_password_mouse_entered():
	hovering_over_button($CenterContainer/VBoxContainer/btn_password)
func _on_btn_save_mouse_entered():
	hovering_over_button($CenterContainer/VBoxContainer/btn_save)
func _on_btn_new_game_mouse_entered():
	hovering_over_button($CenterContainer2/VBoxContainer/btn_new_game)
func _on_btn_load_game_mouse_entered():
	if $CenterContainer2/VBoxContainer/btn_load_game.modulate == Color(1,1,1,1):
		hovering_over_button($CenterContainer2/VBoxContainer/btn_load_game)
func _on_btn_options_mouse_entered():
	hovering_over_button($CenterContainer2/VBoxContainer/btn_options)
func _on_website_button_mouse_entered():
	hovering_over_button($website_button)
func _on_force_website_mouse_entered():
	hovering_over_button($force_update_overlay/force_website)


func _on_btn_campaign_mouse_exited():
	unhover_button($CenterContainer/VBoxContainer/btn_campaign)
func _on_btn_tournament_mouse_exited():
	unhover_button($CenterContainer/VBoxContainer/btn_tournament)
func _on_btn_free_duel_mouse_exited():
	unhover_button($CenterContainer/VBoxContainer/btn_free_duel)
func _on_btn_build_deck_mouse_exited():
	unhover_button($CenterContainer/VBoxContainer/btn_build_deck)
func _on_btn_library_mouse_exited():
	unhover_button($CenterContainer/VBoxContainer/btn_library)
func _on_btn_password_mouse_exited():
	unhover_button($CenterContainer/VBoxContainer/btn_password)
func _on_btn_save_mouse_exited():
	unhover_button($CenterContainer/VBoxContainer/btn_save)
func _on_btn_new_game_mouse_exited():
	unhover_button($CenterContainer2/VBoxContainer/btn_new_game)
func _on_btn_load_game_mouse_exited():
	unhover_button($CenterContainer2/VBoxContainer/btn_load_game)
func _on_btn_options_mouse_exited():
	unhover_button($CenterContainer2/VBoxContainer/btn_options)
func _on_website_button_mouse_exited():
	unhover_button($website_button)
func _on_force_website_mouse_exited():
	unhover_button($force_update_overlay/force_website)


func hovering_over_button(button : Node):
	if button.modulate == Color(1,1,1,1):
		get_node(String(button.get_path()) + "/white_over").show()
func unhover_button(button : Node):
	get_node(String(button.get_path()) + "/white_over").hide()
