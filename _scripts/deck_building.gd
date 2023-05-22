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
	else:
		$user_interface/back_button.modulate = Color(1, 1, 1, 1)
	
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
