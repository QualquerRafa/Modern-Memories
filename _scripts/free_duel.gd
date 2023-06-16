extends Node2D

var cards_per_line = 13 #Shows 13 cards per line, use this to count how many have to be hidden
var active_duelist_name = ""

#---------------------------------------------------------------------------------------------------
func _ready():
	#Animate the transition when starting this scene
	$scene_transitioner.entering_this_scene()
	
	#Initialize stuff on 'card_info_box' hidden
	$user_interface/card_info_box/colored_bar.hide()
	$user_interface/card_info_box/card_name.hide()
	$user_interface/card_info_box/atk_def.hide()
	$user_interface/card_info_box/extra_icons.hide()
	$user_interface/card_info_box/card_text.hide()
	
	#Show the buttons for each unlocked duelist
	var unlocked_duelists = $npc_decks_gd.list_of_decks.keys()
	var containter_for_duelists = $panel_left/duelist_buttons/VBoxContainer
	for duelist in (unlocked_duelists):
		var duelist_slot_node = preload("res://_scenes/duelist_slot.tscn")
		var duelist_slot_instance = duelist_slot_node.instance()
		
		duelist_slot_instance.this_duelist_name = duelist
		duelist_slot_instance.modulate = Color(0.5, 0.5, 0.5, 1)
		containter_for_duelists.add_child(duelist_slot_instance)
	
	#First update using the first unlocked duelist
	update_duelist_cards(unlocked_duelists[0])
	containter_for_duelists.get_child(0).active_this_duelist()

#---------------------------------------------------------------------------------------------------
func update_duelist_cards(duelist_name):
	var containter_for_cards = $panel_right/duelist_cards/MarginContainer/GridContainer/
	var duelist_ref = $npc_decks_gd.list_of_decks[duelist_name]
	
	#Starting by making visible only the nodes that are needed
	var total_cards_displayed = 200 #duelist_ref.UR.size() + duelist_ref.SR.size() + duelist_ref.R.size() + duelist_ref.C.size()
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
	
	$user_interface/UI_tween.interpolate_property($panel_left/go_duel, "rect_scale", $panel_left/go_duel.rect_scale, Vector2(0.9, 0.9), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$user_interface/UI_tween.start()
	yield($user_interface/UI_tween, "tween_completed")
	$user_interface/UI_tween.interpolate_property($panel_left/go_duel, "rect_scale", $panel_left/go_duel.rect_scale, Vector2(1, 1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
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
	
	#Return to Main Menu screen
	$scene_transitioner.scene_transition("main_menu")
