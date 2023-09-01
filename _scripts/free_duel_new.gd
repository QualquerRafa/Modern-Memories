extends Node2D

var cards_per_line = 13 #Shows 13 cards per line, use this to count how many have to be hidden
var active_duelist_name = ""

#Load the "wins" and "losses" text only once, to reduce lag
var language_wins = GameLanguage.free_duel.wins[PlayerData.game_language]
var language_losses = GameLanguage.free_duel.losses[PlayerData.game_language]

func _ready():
	#Animate the transition when starting this scene
	$scene_transitioner.entering_this_scene()
	
	#Get everything on the correct language
	$user_interface/top_info_box/window_title.text = GameLanguage.free_duel.scene_title[PlayerData.game_language]
	$duelist_focus/go_duel/label.text = GameLanguage.system.duel[PlayerData.game_language]
	
	#Initialize stuff on 'card_info_box' hidden
	$user_interface/card_info_box/colored_bar.hide()
	$user_interface/card_info_box/card_name.hide()
	$user_interface/card_info_box/atk_def.hide()
	$user_interface/card_info_box/extra_icons.hide()
	$user_interface/card_info_box/card_text.hide()
	
	#Show the buttons for each unlocked duelist

func duelist_face_clicked(duelist_name):
	#Update with the correct duelist information
	$duelist_focus/duelist_body.texture = load("res://_resources/character_bodys/" + duelist_name + ".png")
	$duelist_focus/duelist_name_label.text = duelist_name
	
	#Special Adjusts for each duelist art
	match duelist_name:
		"kaiba":
			$duelist_focus/duelist_body.position = Vector2(215, 380)
			$duelist_focus/duelist_body.scale = Vector2(1, 1)
		"pegasus":
			$duelist_focus/duelist_body.position = Vector2(195, 365)
			$duelist_focus/duelist_body.scale = Vector2(0.9, 0.9)
		"nitemare":
			$duelist_focus/duelist_body.position = Vector2(280, 385)
			$duelist_focus/duelist_body.scale = Vector2(1.0, 1.0)
		"crowler":
			$duelist_focus/duelist_body.position = Vector2(250, 380)
			$duelist_focus/duelist_body.scale = Vector2(1, 1)
		"chazz":
			$duelist_focus/duelist_body.position = Vector2(185, 220)
			$duelist_focus/duelist_body.scale = Vector2(0.85, 0.85)
		"blair":
			$duelist_focus/duelist_body.position = Vector2(270, 300)
			$duelist_focus/duelist_body.scale = Vector2(0.9, 0.9)
		"hassleberry":
			$duelist_focus/duelist_body.position = Vector2(270, 340)
			$duelist_focus/duelist_body.scale = Vector2(0.9, 0.9)
		"bastion":
			$duelist_focus/duelist_body.position = Vector2(250, 320)
			$duelist_focus/duelist_body.scale = Vector2(0.85, 0.85)
		"syrus":
			$duelist_focus/duelist_body.position = Vector2(250, 350)
			$duelist_focus/duelist_body.scale = Vector2(0.85, 0.85)
		"alexis":
			$duelist_focus/duelist_body.position = Vector2(310, 310)
			$duelist_focus/duelist_body.scale = Vector2(0.85, 0.85)
		"jesse":
			$duelist_focus/duelist_body.position = Vector2(260, 330)
			$duelist_focus/duelist_body.scale = Vector2(0.85, 0.85)
		"zane":
			$duelist_focus/duelist_body.position = Vector2(260, 320)
			$duelist_focus/duelist_body.scale = Vector2(0.9, 0.9)
		"atticus":
			$duelist_focus/duelist_body.position = Vector2(270, 330)
			$duelist_focus/duelist_body.scale = Vector2(0.85, 0.85)
		"aster":
			$duelist_focus/duelist_body.position = Vector2(290, 360)
			$duelist_focus/duelist_body.scale = Vector2(0.85, 0.85)
		"jaden":
			$duelist_focus/duelist_body.position = Vector2(280, 340)
			$duelist_focus/duelist_body.scale = Vector2(0.9, 0.9)
		"nightshroud":
			$duelist_focus/duelist_body.position = Vector2(210, 330)
			$duelist_focus/duelist_body.scale = Vector2(0.85, 0.85)
		_: #DEFAULT
			$duelist_focus/duelist_body.position = Vector2(236, 385)
			$duelist_focus/duelist_body.scale = Vector2(1.0, 1.0)
	
	#Check for duelist names in other languages
	if GameLanguage.free_duel.duelist_names.keys().has(duelist_name):
		$duelist_focus/duelist_name_label.text = GameLanguage.free_duel.duelist_names[duelist_name][PlayerData.game_language]
	
	if PlayerData.recorded_duels.keys().has(duelist_name):
		$duelist_focus/duelist_wins.text = language_wins + String(PlayerData.recorded_duels[duelist_name].W)
		$duelist_focus/duelist_losses.text = language_losses + String(PlayerData.recorded_duels[duelist_name].L)
	else:
		$duelist_focus/duelist_wins.text = language_wins + "0"
		$duelist_focus/duelist_losses.text = language_losses + "0"
	update_duelist_cards(duelist_name)
	active_duelist_name = duelist_name
	
	#Duelist Focus animations
	$duelist_focus.modulate = Color(0,0,0,0)
	$duelist_focus.show()
	$duelist_focus/tween.interpolate_property($duelist_focus, "modulate", $duelist_focus.modulate, Color(1,1,1,1), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$duelist_focus/tween.start()
	#yield($duelist_focus/tween, "tween_completed")
	
	#Panel Right animations
	var out_position = Vector2(1000,0)
	var in_position = Vector2(0,0)
	$panel_right.position = out_position
	$panel_right.show()
	$panel_right/tween.interpolate_property($panel_right, "position", $panel_right.position, in_position, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$panel_right/tween.start()
	#yield($panel_right/tween, "tween_completed")

func _on_defocus_button_button_up():
	defocus_duelist()

func defocus_duelist():
	#Put stuff on 'card_info_box' hidden
	$user_interface/card_info_box/colored_bar.hide()
	$user_interface/card_info_box/card_name.hide()
	$user_interface/card_info_box/atk_def.hide()
	$user_interface/card_info_box/extra_icons.hide()
	$user_interface/card_info_box/card_text.hide()
	
	#Fade out the duelist focus
	$duelist_focus/tween.interpolate_property($duelist_focus, "modulate", $duelist_focus.modulate, Color(0,0,0,0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$duelist_focus/tween.start()
	
	$panel_right/tween.interpolate_property($panel_right, "position", $panel_right.position, Vector2(1000,0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$panel_right/tween.start()
	
	yield($duelist_focus/tween, "tween_completed")
	$duelist_focus.hide()
	$panel_right.hide()

#---------------------------------------------------------------------------------------------------
func update_duelist_cards(duelist_name):
	var containter_for_cards = $panel_right/duelist_cards/MarginContainer/GridContainer/
	var duelist_ref = $npc_decks_gd.list_of_decks[duelist_name]
	
	#Starting by making visible only the nodes that are needed
	var total_cards_displayed = containter_for_cards.get_child_count() #duelist_ref.UR.size() + duelist_ref.SR.size() + duelist_ref.R.size() + duelist_ref.C.size()
	for i in range(total_cards_displayed):
		containter_for_cards.get_child(i).show()
	
	#UPDATE CARD LIST
	var rarities = ["UR", "SR", "R", "C"]
	var last_index_already_used = 0
	for rarity in rarities:
		var count_rarity = duelist_ref[rarity].size()
		for i in range(count_rarity):
			containter_for_cards.get_child(last_index_already_used + i).update_card_information(duelist_ref[rarity][i].pad_zeros(5))
			containter_for_cards.get_child(last_index_already_used + i).get_child(0).get_child(2).texture = load("res://_resources/free_duel/rarity_" + rarity + ".png")
			containter_for_cards.get_child(last_index_already_used + i).get_child(0).show() #rarity_card.z_indexer
			
			#Darken cards that the player doesn't have
			if PlayerData.player_trunk.keys().has(duelist_ref[rarity][i].pad_zeros(5)):
				containter_for_cards.get_child(last_index_already_used + i).get_child(0).modulate = Color(1, 1, 1, 1)
			else:
				containter_for_cards.get_child(last_index_already_used + i).get_child(0).modulate = Color(0.3, 0.3, 0.3, 1)
		
		var remaining_on_line : int
		if count_rarity <= 1*cards_per_line:
			remaining_on_line = cards_per_line - count_rarity
		elif count_rarity <= 2*cards_per_line:
			remaining_on_line = 2*(cards_per_line) - count_rarity
		elif count_rarity <= 3*cards_per_line:
			remaining_on_line = 3*(cards_per_line) - count_rarity
		elif count_rarity <= 4*cards_per_line:
			remaining_on_line = 4*cards_per_line - count_rarity
		elif count_rarity <= 5*cards_per_line:
			remaining_on_line = 5*cards_per_line - count_rarity
		
		for i in range(remaining_on_line):
			containter_for_cards.get_child(last_index_already_used + count_rarity + i).get_child(0).hide() #rarity_card.z_indexer
		last_index_already_used += count_rarity + remaining_on_line
	
	#Hide whatever node is left at the end of the process
	var unused_node_count = containter_for_cards.get_children().size() - last_index_already_used
	for i in range(unused_node_count):
		containter_for_cards.get_child(last_index_already_used + i).hide()

#---------------------------------------------------------------------------------------------------
func _on_go_duel_button_up():
	SoundControl.play_sound("poc_decide")
	
	$user_interface/UI_tween.interpolate_property($duelist_focus/go_duel, "rect_scale", $duelist_focus/go_duel.rect_scale, Vector2(0.9, 0.9), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$user_interface/UI_tween.start()
	yield($user_interface/UI_tween, "tween_completed")
	$user_interface/UI_tween.interpolate_property($duelist_focus/go_duel, "rect_scale", $duelist_focus/go_duel.rect_scale, Vector2(1, 1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$user_interface/UI_tween.start()
	
	PlayerData.going_to_duel = active_duelist_name
	PlayerData.scene_to_return_after_duel = "free_duel"
	$scene_transitioner.scene_transition("deck_building")

#---------------------------------------------------------------------------------------------------
func _on_back_button_button_up():
	SoundControl.play_sound("poc_decide")
	
	#Animate the button being clicked
	var small_scale = Vector2(0.8 , 0.8)
	var normal_scale = Vector2(1 , 1)
	$user_interface/UI_tween.interpolate_property($user_interface/back_button, "rect_scale", $user_interface/back_button.rect_scale, small_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$user_interface/UI_tween.start()
	yield($user_interface/UI_tween, "tween_completed")
	$user_interface/UI_tween.interpolate_property($user_interface/back_button, "rect_scale", $user_interface/back_button.rect_scale, normal_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$user_interface/UI_tween.start()
	
	if $panel_right.is_visible(): #If duelist is on focus, unfocus
		defocus_duelist()
	else: #On usual cases, return to main menu
		$scene_transitioner.scene_transition("main_menu")




