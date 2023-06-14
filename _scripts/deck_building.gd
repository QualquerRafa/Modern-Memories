extends Node2D

var player_trunk : Dictionary = PlayerData.player_trunk
var current_highlighted_card : Node

func _ready():
	#Animate the transition when starting this scene
	$scene_transitioner.entering_this_scene()
	
	#Initialize stuff on 'card_info_box' hidden
	$user_interface/card_info_box/colored_bar.hide()
	$user_interface/card_info_box/card_name.hide()
	$user_interface/card_info_box/atk_def.hide()
	$user_interface/card_info_box/extra_icons.hide()
	$user_interface/card_info_box/card_text.hide()
	
	#If the player is about to start a duel, show only the correct buttons for it
	if PlayerData.going_to_duel != "":
		about_to_duel_correct_buttons()
	
	#Do the first sort of cards for the trunk byNEW
	var first_sorted_left = $panel_left/sortables.sort_cards(PlayerData.player_trunk.keys(), "new")
	
	#Update the screen with the correct cards
	update_right_panel()
	update_left_panel(first_sorted_left)

#---------------------------------------------------------------------------------------------------
func update_right_panel():
	#At first, sort the deck by atk so it's indiretely sorted by atk and type by the end
	PlayerData.player_deck = $panel_left/sortables.sort_with_duplicates(PlayerData.player_deck, "atk")
	
	#Organize the player cards by type
	var player_deck_normal_cards = []; var player_deck_effect_cards = []; var player_deck_spell_cards = []; var player_deck_trap_cards = []; var player_deck_ritual_cards = []
	for i in range(PlayerData.player_deck.size()):
		if CardList.card_list[PlayerData.player_deck[i]].effect.size() == 0:
			player_deck_normal_cards.append(PlayerData.player_deck[i])
		else:
			match CardList.card_list[PlayerData.player_deck[i]].attribute:
				"spell":
					if CardList.card_list[PlayerData.player_deck[i]].type == "ritual":
						player_deck_ritual_cards.append(PlayerData.player_deck[i])
					else:
						player_deck_spell_cards.append(PlayerData.player_deck[i])
				"trap":
					player_deck_trap_cards.append(PlayerData.player_deck[i])
				_: #monsters
					player_deck_effect_cards.append(PlayerData.player_deck[i])
	#'Re-sort' player_deck at the end
	PlayerData.player_deck = player_deck_normal_cards + player_deck_effect_cards + player_deck_spell_cards + player_deck_trap_cards + player_deck_ritual_cards
	#player_deck = PlayerData.player_deck
	
	#Update the CardIndicators
	$panel_right/CardsIndicator/count_deck.text = String(PlayerData.player_deck.size())
	$panel_right/CardsIndicator/count_normal.text = String(player_deck_normal_cards.size())
	$panel_right/CardsIndicator/count_effect.text = String(player_deck_effect_cards.size())
	$panel_right/CardsIndicator/count_spell.text = String(player_deck_spell_cards.size())
	$panel_right/CardsIndicator/count_trap.text = String(player_deck_trap_cards.size())
	$panel_right/CardsIndicator/count_ritual.text = String(player_deck_ritual_cards.size())
	
	#Unable the button to leave the Deck Building screen if the Deck doesn't have 40 cards
	if PlayerData.player_deck.size() < 40:
		$user_interface/back_button.modulate = Color(0.5, 0.5, 0.5, 0.9)
		$panel_right/deck_buttons/button_go_duel.modulate = Color(0.5, 0.5, 0.5, 0.9)
	else:
		$user_interface/back_button.modulate = Color(1, 1, 1, 1)
		$panel_right/deck_buttons/button_go_duel.modulate = Color(1, 1, 1, 1)
	
	#Hide the nodes that don't correspond to a card in deck
	for i in range(40 - (40 - PlayerData.player_deck.size()), 40):
		var visual_deck_card = $panel_right/deck_cards/MarginContainer/GridContainer.get_child(i)
		visual_deck_card.hide()
	
	#Update the visual cards
	for i in range(PlayerData.player_deck.size()):
		var visual_deck_card = $panel_right/deck_cards/MarginContainer/GridContainer.get_child(i)
		visual_deck_card.update_card_information(PlayerData.player_deck[i])
		visual_deck_card.show()

#---------------------------------------------------------------------------------------------------
func update_left_panel(player_trunk_as_array):
	if current_highlighted_card != null:
		var node_onScreen_position_X = current_highlighted_card.get_global_transform_with_canvas()[2][0]
		if node_onScreen_position_X <= 1280/2:
			current_highlighted_card = null
	
	#Hide any node that doesn't have a corresponding card in the trunk
	var number_of_cards_player_doesnt_have = CardList.card_list.keys().size() - PlayerData.player_trunk.keys().size()
	for _i in range(number_of_cards_player_doesnt_have):
		$panel_left/ScrollContainer/MarginContainer/GridContainer.get_children()[-1].hide()
	
	#Show the necessary nodes and update them with the correct information
	for i in range(player_trunk_as_array.size()):
		$panel_left/ScrollContainer/MarginContainer/GridContainer.get_child(i).update_card_information(player_trunk_as_array[i])
		if !($panel_left/ScrollContainer/MarginContainer/GridContainer.get_child(i).is_visible()):
			$panel_left/ScrollContainer/MarginContainer/GridContainer.get_child(i).show()
		
		#Indicate the number of copies and visibility to add/remove to deck
		var card_ID_in_trunk = player_trunk_as_array[i]
		var copies_counter = PlayerData.player_trunk[card_ID_in_trunk]
		var trunk_counter_label = $panel_left/ScrollContainer/MarginContainer/GridContainer.get_child(i).get_child(0).get_child(1)
		
		if PlayerData.player_deck.has(card_ID_in_trunk):
			var how_many_in_deck = PlayerData.player_deck.count(card_ID_in_trunk)
			copies_counter -= how_many_in_deck
		
		trunk_counter_label.text = String(copies_counter)
		trunk_counter_label.show()
		
		#Change the opacity of cards with 0 copies
		if copies_counter == 0:
			$panel_left/ScrollContainer/MarginContainer/GridContainer.get_child(i).modulate = Color(0.42,0.42,0.42,1)
		else:
			$panel_left/ScrollContainer/MarginContainer/GridContainer.get_child(i).modulate = Color(1,1,1,1)

#---------------------------------------------------------------------------------------------------
# DECK BUTTONS
#---------------------------------------------------------------------------------------------------
func about_to_duel_correct_buttons():
	#Un-nable the go_back button
	$user_interface/back_button.hide()
	
	#Show the go_duel button
	$panel_right/deck_buttons/button_go_duel.show()
	
	#Hide the other deck buttons
	$panel_right/deck_buttons/button_auto.hide()
	$panel_right/deck_buttons/button_clear.hide()
	$panel_right/deck_buttons/button_import.hide()
	$panel_right/deck_buttons/button_export.hide()

#Only visible if the player is about to enter a duel
func _on_go_duel_button_up():
	#Check if the player deck has 40 cards
	if PlayerData.player_deck.size() == 40:
		$scene_transitioner.scene_transition("duel_scene")

func _on_clear_deck_button_up():
	PlayerData.player_deck.clear()
	update_right_panel()
	var resorted_trunk = $panel_left/sortables.sort_cards(PlayerData.player_trunk.keys(), "new")
	update_left_panel(resorted_trunk)

func _on_export_deck_button_up():
	export_player_deck()
func export_player_deck():
	#Generate the deck string
	var deck_string : String = ""
	var player_deck : Array = PlayerData.player_deck
	
	var temp_deck_as_dictionary = {}
	for card in player_deck:
		if card in temp_deck_as_dictionary:
			temp_deck_as_dictionary[card] += 1 #register another copy of the card to the already existing id key
		else: 
			temp_deck_as_dictionary[card] = 1 #card is not in trunk, so add it's key:value pair as id:count
	
	for card in temp_deck_as_dictionary.keys():
		deck_string += card + String(temp_deck_as_dictionary[card])
	$import_export_canvas/export_window/exported_string.text = deck_string
	
	#Show everything
	$import_export_canvas.show()
	$import_export_canvas/export_window.show()
	$import_export_canvas/import_window.hide()
func _on_export_close_button_up():
	$import_export_canvas.hide()

#For importing the logic is a bit different
func _on_import_deck_button_up():
	#Show everything
	$import_export_canvas.show()
	$import_export_canvas/export_window.hide()
	$import_export_canvas/import_window.show()
func _on_import_string_input_text_changed(entered_string):
	$import_export_canvas/import_window/import_string_visual.text = entered_string
func _on_import_close_button_up():
	#do the checks on the entered string to generate a deck from it
	var entered_string = $import_export_canvas/import_window/import_string_visual.text
	
	#If there is no string inputed, just close the window without doing anything
	if entered_string.length() < 1:
		$import_export_canvas.hide()
		return
	
	#If there is any character that isn't a number, fail to close the window
	if not entered_string.is_valid_integer():
		print("has something else than numbers")
		return
	
	#Splice the entered string into 6 digit packets, since card ID is 5 digits and the 6th is the amount of copies
	var entered_string_splices : Array = []
	var multiples_of_six = entered_string.length()/6
	for _i in range(multiples_of_six):
		var six_digits = entered_string.left(6)
		entered_string_splices.append(six_digits)
		entered_string = entered_string.trim_prefix(six_digits)
	
	#Transform the Array with spliced strings into a deck for the player
	var deck_to_be_generated : Array = []
	for card_code in entered_string_splices:
		var card_id = card_code.left(5)
		var copies = card_code.trim_prefix(card_id)
		#print("FULL: ", card_code, " ID: ", card_id, " COPIES: ", copies)
		
		#If the player has that card in their trunk, add to the new deck
		if PlayerData.player_trunk.keys().has(card_id):
			var player_number_of_copies = PlayerData.player_trunk[card_id]
			for _i in range(player_number_of_copies):
				if deck_to_be_generated.count(card_id) < int(copies):
					deck_to_be_generated.append(card_id)
	
	#print("Player Deck: ", PlayerData.player_deck)
	#print("Imported Deck: ", deck_to_be_generated)
	
	#Update the actual player Deck and screen visuals
	PlayerData.player_deck = deck_to_be_generated
	update_right_panel()
	var resorted_trunk = $panel_left/sortables.sort_cards(PlayerData.player_trunk.keys(), "new")
	update_left_panel(resorted_trunk)
	
	#Finally hide the window
	$import_export_canvas/import_window/import_string_input.clear()
	$import_export_canvas.hide()

#---------------------------------------------------------------------------------------------------
func _on_back_button_button_up():
	#If button isn't enabled, don't change scene
	if $user_interface/back_button.modulate != Color(1, 1, 1, 1):
		return
	
	#Animate the button being clicked
	var small_scale = Vector2(0.8 , 0.8)
	var normal_scale = Vector2(1 , 1)
	$user_interface/UI_tween.interpolate_property($user_interface/back_button, "rect_scale", $user_interface/back_button.rect_scale, small_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$user_interface/UI_tween.start()
	yield($user_interface/UI_tween, "tween_completed")
	$user_interface/UI_tween.interpolate_property($user_interface/back_button, "rect_scale", $user_interface/back_button.rect_scale, normal_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$user_interface/UI_tween.start()
	
	#Return to Main Menu screen
	if PlayerData.going_to_duel == "":
		$scene_transitioner.scene_transition("main_menu")
	else:
		$scene_transitioner.scene_transition("free_duel")


