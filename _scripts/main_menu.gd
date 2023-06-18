extends Node2D

func _ready():
	#Animate the transition when starting this scene
	$scene_transitioner.entering_this_scene()
	
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
	animate_button($save_load_overlay/save_warning/button_close/export_close)
	
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
	$timer.start(1); yield($timer, "timeout") #give it some time
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
func _on_btn_new_game_button_up():
	animate_button($CenterContainer2/VBoxContainer/btn_new_game)
	#Create a new Player Deck
	if PlayerData.player_deck.size() == 0:
		var _DEBUG_initialize_Player_Deck : Array = PlayerData.create_player_deck()
	PlayerData.game_loaded = true #even though this is not a proper load, a New Game sets this variable as well
	
	#In the future, this function should throw the player directly to the Campaign first scene. For now, to the next menu page
	separation_of_boxes()

func _on_btn_load_game_button_up():
	if $CenterContainer2/VBoxContainer/btn_load_game.modulate == Color(1,1,1,1):
		animate_button($CenterContainer2/VBoxContainer/btn_load_game)
		load_game() #will emit the signal 'game_loaded' once everything is properly loaded

func _on_btn_options_button_up():
	animate_button($CenterContainer2/VBoxContainer/btn_options)
	change_scene("options_scene")

func _on_btn_campaign_button_up():
	SoundControl.play_sound("poc_unable")
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
	pass #hovering_over_button($CenterContainer/VBoxContainer/btn_campaign)
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

func hovering_over_button(button : Node):
	if button.modulate == Color(1,1,1,1):
		get_node(String(button.get_path()) + "/white_over").show()
func unhover_button(button : Node):
	get_node(String(button.get_path()) + "/white_over").hide()











