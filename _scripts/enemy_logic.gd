extends Node

onready var GAME_LOGIC = get_node("../")
signal after_try_move_ahead

#Enemy Specific Variables
var enemy_LP : int
var enemy_deck : Array = []
var enemy_hand : Array = [] #stores card IDs

#-------------------------------------------------------------------------------
func _ready():
	#Load  Enemy Deck
	enemy_deck = $npc_decks_gd.get_a_deck(PlayerData.going_to_duel)
	enemy_deck.shuffle()

#-------------------------------------------------------------------------------
func enemy_draw_phase():
	GAME_LOGIC.GAME_PHASE = "enemy_draw_phase"
	
	#Pull the necessary amount of cards to Enemy's Hand
	var cards_to_pull = 5 - enemy_hand.size()
	if enemy_deck.size() >= cards_to_pull: #if enemy has enough cards to pull
		for _i in range(cards_to_pull):
			enemy_hand.append(enemy_deck[0]) #add to the hand the first card from deck
			enemy_deck.remove(0) #remove that same card from deck
			
			#Update visual counter for deck size
			get_node("../../user_interface/top_info_box/com_info/deck").text = String(enemy_deck.size())
			$enemy_timer.start(0.2); yield($enemy_timer, "timeout")
	else:
		print("Enemy deck run out")
		GAME_LOGIC.check_for_game_end("COM_deck_out")
		return "exit game"
	
	#Change enemy Hand for testing purposes
	#enemy_hand = ["00649", "00624", "00624", "00624", "00624"]
	#print("--------------------------------------------------")
	#for card in enemy_hand:
	#	print(CardList.card_list[card].card_name, "// ATK: ", CardList.card_list[card].atk, " DEF: ", CardList.card_list[card].def)
	#print("--------------------------------------------------")
	
	#Reset the 'has_battled' for all monsters on the field
	for i in range(5):
		var this_i_monster : Node = get_node("../../duel_field/enemy_side_zones/monster_" + String(i))
		if this_i_monster.is_visible():
			this_i_monster.this_card_flags.has_battled = false
	
	#Reset this at the start of the turn in case needed
	if GAME_LOGIC.waboku_protection == true:
		GAME_LOGIC.waboku_protection = false
	
	#Wait some time during draw_phase for better game flow
	$enemy_timer.start(0.3); yield($enemy_timer, "timeout")
	
	#Move to enemy's next phase
	enemy_choosing_card_to_play()

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# THE PROCESS OF CHOOSING A CARD TO PLAY
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
func enemy_choosing_card_to_play():
	GAME_LOGIC.GAME_PHASE = "enemy_choosing_card"
	
	#START BY FIGURING OUT IF COM IS AT DISADVANTAGE OR NOT
	var player_has_more_monsters_than_com : bool = false
	var player_monster_list : Array = get_field_monsters_array("player") #these come back sorted by Highest atk to lowest
	var com_monster_list : Array = get_field_monsters_array("enemy") #these come back sorted by Highest atk to lowest
	
	if player_monster_list.size() > com_monster_list.size():
		player_has_more_monsters_than_com = true
	
	#Initialize the function of the final choosen card
	var final_card_to_play : Array = ["", ""] #["spelltrap" or "monster", card_id, {third element is optional, happens when two cards are going to be fused}]
	
	#PROCEED IN 2 DIFFERENT WAYS DEPENDING ON THE SITUATION COM IS AT
	if player_has_more_monsters_than_com == false:
		if com_monster_list.size() != 0:
			#Look at support spells it can play: Field Spells, Generic Spells, Rituals
			var acceptable_support_spells = ["Gaia Power", "Molten Destruction", "Rising Air Current", "Umiiruka", "Luminous Spark", "Mystic Plasma Zone",]
			if player_monster_list.size() >= 2:
				acceptable_support_spells.push_front("Skull Dice")
				acceptable_support_spells.push_front("Raigeki")
				acceptable_support_spells.push_back("Change of Heart")
			for i in range(5):
				if get_node("../../duel_field/player_side_zones/spelltrap_" + String(i)).is_visible():
					acceptable_support_spells.push_front("Harpie's Feather Duster")
					break
			for i in range(5):
				if get_node("../../duel_field/enemy_side_zones/monster_" + String(i)).is_visible() and get_node("../../duel_field/enemy_side_zones/monster_" + String(i)).this_card_flags.is_facedown == false:
					acceptable_support_spells.push_front("Graceful Dice")
					break
			
			for card in enemy_hand: #cards are 'id : String' while in 'enemy_hand'
				if CardList.card_list[card].attribute == "spell" and CardList.card_list[card].card_name in acceptable_support_spells:
					final_card_to_play = ["spelltrap", card]
					break #The first card found is enough already
			
			#Catch the result of choosing a spell. If a card was already chosen, skip all other checks bellow
			if final_card_to_play[0] == "spelltrap":
				enemy_play_that_card(final_card_to_play)
				return #get out of this function
		
		#Roll for a chance of doing a Fusion, and if that is stronger than the card in COMs hand, play the Fusion
		final_card_to_play = ["monster", get_strongest_monster_in_hand()] #By default, just the Strongest Monster in hand
		
		randomize()
		var fusion_roll = randf()
		if fusion_roll <= 0.75:
			var fusion_of_cards = look_for_fusion_in_hand() #returns as an Empty array if it fails, or [card_a, card_b, fusion_atk]
			if fusion_of_cards.size() != 0 and fusion_of_cards[2] >= CardList.card_list[get_strongest_monster_in_hand()].atk:
				final_card_to_play = ["monster", fusion_of_cards[0], fusion_of_cards[1]]
		
		#Catch the result of choosing a Monster. If a card was already chosen, skip all other checks bellow
		if final_card_to_play[0] == "monster":
			enemy_play_that_card(final_card_to_play)
			return #get out of this function
	
	elif player_has_more_monsters_than_com == true:
		#Look for monsters with destroy_all_enemy_monsters that it can play
		randomize()
		var rand_chance_of_destroy_all = randf()
		if player_monster_list.size() >= 2 and rand_chance_of_destroy_all <= 0.35:
			for card_id in enemy_hand:
				if not CardList.card_list[card_id].attribute in ["spell", "trap"] and CardList.card_list[card_id].effect.size() > 2 and typeof(CardList.card_list[card_id].effect[2]) == TYPE_STRING and CardList.card_list[card_id].effect[2] == "all_enemy_monsters":
					final_card_to_play = ["monster", card_id]
					enemy_play_that_card(final_card_to_play)
					return
		
		#Look for monsters with effects that have the potential to turn the game
		for card_id in enemy_hand:
			if not CardList.card_list[card_id].attribute in ["spell", "trap"]:
				if player_monster_list.size() >= 2 and CardList.card_list[card_id].card_name in ["Gandora the Dragon of Destruction", "The Wicked Avatar", "The Wicked Eraser"]: #Monsters with 0 attack but specific effects that would be skipped
					final_card_to_play = ["monster", card_id]
					break
				elif CardList.card_list[card_id].effect.size() > 2 and CardList.card_list[card_id].effect[0] == "on_summon" and CardList.card_list[card_id].effect[2] in ["random_monster", "atk_highest"]: #on_summon, destroy_card, random_monster
					final_card_to_play = ["monster", card_id]
					break
				elif CardList.card_list[card_id].effect.size() > 1 and CardList.card_list[card_id].effect[1] == "mutual_banish": #on_attack, mutual_banish
					final_card_to_play = ["monster", card_id]
					break
				elif CardList.card_list[card_id].effect.size() > 1 and CardList.card_list[card_id].effect[1] == "copy_atk":
					final_card_to_play = ["monster", card_id]
					break
				elif CardList.card_list[card_id].effect.size() > 1 and CardList.card_list[card_id].effect[1] == "graveyard_power_up" and enemy_deck.size() <= 30:
					final_card_to_play = ["monster", card_id]
					break
				elif CardList.card_list[card_id].effect.size() > 1 and CardList.card_list[card_id].effect[1] in ["can_direct", "toon"] and CardList.card_list[card_id].atk >= int(get_node("../../user_interface/top_info_box/player_info/lifepoints").text):
					final_card_to_play = ["monster", card_id]
					break
		#Catch the result of choosing a Monster. If a card was already chosen, skip all other checks bellow
		if final_card_to_play[0] == "monster":
			enemy_play_that_card(final_card_to_play)
			return #get out of this function
		
		#Look for the strongest monster it could play, either a single card from the hand or a Fusion stronger than anything it has
		final_card_to_play = ["monster", get_strongest_monster_in_hand()]
		var fusion_of_cards = look_for_fusion_in_hand() #returns as an Empty array if it fails, or [card_a, card_b, fusion_atk] or [card_monster, card_spell, [stats_up, value]]
		if fusion_of_cards.size() != 0 and fusion_of_cards[2] >= CardList.card_list[get_strongest_monster_in_hand()].atk:
			final_card_to_play = ["monster", fusion_of_cards[0], fusion_of_cards[1]]
		
		#Look for defensive spells or traps: Raigeki, Mirror Force, or even tokens, etc
		if player_monster_list.size() >= 2:
			var acceptable_agressive_spelltraps = ["Raigeki", "Change of Heart",
												   "Mirror Force", "Waboku", "Enchanted Javelin", "Magic Cylinder", "Widespread Ruin", "Negate Attack",
												   "Lair of Darkness", "Shield Wall", "Scapegoat", "Spider Egg", "Gadget Box", "Stray Lambs", "Fires of Doomsday", "Haunted Zombies", "Jam Breeding Machine", "Multiplication of Ants", "Wild Fire",
												   "Shield & Sword"]
			if com_monster_list.size() >= 1:
				acceptable_agressive_spelltraps.push_front("Castle Walls")
				acceptable_agressive_spelltraps.append("Block Attack")
			
			for card in enemy_hand: #cards are 'id : String' while in 'enemy_hand'
				if CardList.card_list[card].attribute in ["spell", "trap"] and CardList.card_list[card].card_name in acceptable_agressive_spelltraps:
					final_card_to_play = ["spelltrap", card]
					break #The first card found is enough already
			#Catch the result of choosing a spell. If a card was already chosen, skip all other checks bellow
			if final_card_to_play[0] == "spelltrap":
				enemy_play_that_card(final_card_to_play)
				return #get out of this function
		
		#As the last resort, try to play the monster with the highest Def on it's hand
		var com_actual_atk : int
		if final_card_to_play.size() == 2:
			com_actual_atk = CardList.card_list[final_card_to_play[1]].atk
		elif final_card_to_play.size() > 2: #fusion
			com_actual_atk = fusion_of_cards[2]
		
		var player_highest_atk_on_field = 0
		if player_monster_list.size() > 0:
			player_highest_atk_on_field = int(player_monster_list[0].get_node("card_design/monster_features/atk_def/atk").text)
		if com_actual_atk < player_highest_atk_on_field:
			if CardList.card_list[get_strongest_monster_in_hand("def")].def > com_actual_atk:
				#Even the strongest monster COM can play isn't a match for Player's, so look for highest def in hand
				final_card_to_play = ["monster", get_strongest_monster_in_hand("def")]
		#Catch the result of choosing a Monster. If a card was already chosen, skip all other checks bellow
		if final_card_to_play[0] == "monster":
			enemy_play_that_card(final_card_to_play)
			return #get out of this functio
	
	#Final error catching opportunity. If COM couldn't find a card to play at all, give it a generic card to play
	final_card_to_play = ["monster", "00000", []]
	enemy_play_that_card(final_card_to_play)

#------------------------------------    AUXILIARY FUNCTIONS    ------------------------------------
func get_field_monsters_array(which_player : String):
	var initial_monster_array = [] #the array to return at the end
	for i in range(5):
		if get_node("../../duel_field/"+ which_player +"_side_zones/monster_" + String(i)).is_visible():
			var monster_node = get_node("../../duel_field/"+ which_player +"_side_zones/monster_" + String(i))
			initial_monster_array.append(monster_node)
	
	#organize the array order by strongest status
	var temp_atk_array = []
	for i in range(initial_monster_array.size()):
		temp_atk_array.append(int(initial_monster_array[i].get_node("card_design/monster_features/atk_def/atk").text))
	temp_atk_array.sort()
	
	var final_monsters_array = []
	for i in range(temp_atk_array.size()):
		for j in range(initial_monster_array.size()):
			if temp_atk_array[i] == int(initial_monster_array[j].get_node("card_design/monster_features/atk_def/atk").text) and !(final_monsters_array.has(initial_monster_array[j])):
				final_monsters_array.append(initial_monster_array[j])
	final_monsters_array.invert() #for some reason that is unclear to me right now, I had to invert to get the expected order from Highest to Lowest
	
	#if which_player == "player":
	#	print("This is the ", which_player ," monsters array:", final_monsters_array)
	
	return final_monsters_array

func get_strongest_monster_in_hand(atk_or_def = "atk"):
	var strongest_monster_id : String = ""
	var strongest_attack : int = 0
	for i in range(enemy_hand.size()):
		if !(CardList.card_list[enemy_hand[i]].attribute in ["spell", "trap"]) and CardList.card_list[enemy_hand[i]][atk_or_def] >= strongest_attack: #gotta be a monster
			strongest_monster_id = enemy_hand[i]
			strongest_attack = CardList.card_list[strongest_monster_id][atk_or_def]
	
	if strongest_monster_id != "":
		return strongest_monster_id
	else:
		#Safeguard
		return "00000"

func look_for_fusion_in_hand():
	var return_fusion_pair : Array = []
	var card_a; var card_b
	
	#List all the fusions found, they will then be sorted and will return the Strongest one!
	var list_of_found_fusions : Array = []
	
	for i in range(4):
		#For each card in hand, try to pair it with the ones after it. The math checks out, it's beautiful.
		card_a = enemy_hand[i]
		for j in range(4-i):
			card_b = enemy_hand[i+j+1]
			var checking_for_fusion = GAME_LOGIC.fusion_list.check_for_fusion(card_a, card_b)
			
			if typeof(checking_for_fusion[1]) != TYPE_ARRAY: #safeguard for when it returns an equip
				if checking_for_fusion[1] == true: #Returned a Monster Fusion
					list_of_found_fusions.append([checking_for_fusion[0], card_a, card_b]) #fusion result id, cards used to fuse it
			else: #Returned a Equip "fusion". It's okay as well
				if checking_for_fusion[1].size() < 3: #returns for equip are: [monster_card_id, ["stats_up", 0]]
					list_of_found_fusions.append([checking_for_fusion[0], card_a, card_b, checking_for_fusion[1][1]]) #
	
	#Catch the case of no Fusion being found at all
	if list_of_found_fusions.size() == 0:
		return return_fusion_pair #that at this moment would be an empty array
	
	#Sort the fusions encountered to return the best one at the end
	var atk_values = []
	for found_fusion in list_of_found_fusions:
		if found_fusion.size() == 3: #regular fusions
			atk_values.append(CardList.card_list[found_fusion[0]].atk)
		else: #equip "fusions"
			atk_values.append(CardList.card_list[found_fusion[0]].atk + found_fusion[3])
	atk_values.sort()
	
	var sorted_list = []
	for i in range(atk_values.size()):
		for j in range(list_of_found_fusions.size()):
			if list_of_found_fusions[j].size() == 3: #regular fusions
				if atk_values[i] == CardList.card_list[list_of_found_fusions[j][0]].atk and not sorted_list.has(list_of_found_fusions[j]):
					sorted_list.append(list_of_found_fusions[j])
			else:
				if atk_values[i] == (CardList.card_list[list_of_found_fusions[j][0]].atk + list_of_found_fusions[j][3]) and not sorted_list.has(list_of_found_fusions[j]):
					sorted_list.append(list_of_found_fusions[j])
	sorted_list.invert() #for some reason that is unclear to me right now, I had to invert to get the expected order from Highest to Lowest
	
	#Just so it isn't too OP all the time, give a small chance of mercy lol
	var fusion_index = 0
	if atk_values[0] >= 2600 and sorted_list.size() > 1:
		randomize()
		if randf() > 0.8:
			fusion_index = 1 #20% chance to get the SECOND strongest fusion result
			#print("Enemy fusion had mercy!")
	return_fusion_pair = [sorted_list[fusion_index][1], sorted_list[fusion_index][2], atk_values[fusion_index]]
	
	return return_fusion_pair #and returns the atk value of the fusion result

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# THE PROCESS OF PLACING THAT FINAL CHOOSEN CARD ON THE FIELD
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
func enemy_play_that_card(card_to_play_array : Array):
	var kind_of_card : String = card_to_play_array[0] #easy way to say it's a 'monster' or 'spelltrap' for node searching
	#remove the main card being played from enemy hand
	if enemy_hand.has(card_to_play_array[1]):
		enemy_hand.remove(enemy_hand.find(card_to_play_array[1]))
	else:
		var error_prevent_pop = enemy_hand.pop_back()
		print("enemy_play_that_card resorted to a last case scenario and popped ", CardList.card_list[error_prevent_pop].card_name)
	
	#Look for a Field Slot to play
	var field_node_to_use = null
	for i in range(5):
		var invisible_node = get_node("../../duel_field/enemy_side_zones/" + kind_of_card + "_" + String(i))
		if !invisible_node.is_visible():
			field_node_to_use = invisible_node
			break
	#still didn't find a Free field node, use a monster on the field as part of the fusion
	if field_node_to_use == null:
		#Force the weakest card on the field as part of the fusion. It will overide any fusion the COM was planning to do lmao
		var weakest_monster_on_com_field = ""
		var ref_atk = 9999
		
		for i in range(5):
			if int(get_node("../../duel_field/enemy_side_zones/monster_" + String(i)).get_node("card_design/monster_features/atk_def/atk").text) <= ref_atk:
				weakest_monster_on_com_field = get_node("../../duel_field/enemy_side_zones/monster_" + String(i))
				ref_atk = int(get_node("../../duel_field/enemy_side_zones/monster_" + String(i)).get_node("card_design/monster_features/atk_def/atk").text)
		field_node_to_use = weakest_monster_on_com_field
		
		#Rearrange card_to_play_array (it is ["monster", card_1, {card_2}]
		var compose = ["monster", weakest_monster_on_com_field.this_card_id, card_to_play_array[1]]
		card_to_play_array = compose
	
	#Check if a fusion will happen
	var is_fusion_summon : bool = false
	#print(card_to_play_array)
	if kind_of_card == "monster" and card_to_play_array.size() > 2 and typeof(card_to_play_array[2]) == TYPE_STRING: #an optional secondary ID was passed, fuse it with first card passed:
		#I have to check here once again in case the field is full, just so it doesn't Summon the new card over another as a Purple Border
		var verify_the_fusion = GAME_LOGIC.fusion_list.check_for_fusion(card_to_play_array[1], card_to_play_array[2])
		#print(verify_the_fusion)
		if typeof(verify_the_fusion[1]) != TYPE_ARRAY: #safeguard for when it returns an equip
			if verify_the_fusion[1] == true: #Returned a Monster Fusion
				is_fusion_summon = true
		else:
			if verify_the_fusion[1][1] != 0: #Equip didn't fail
				is_fusion_summon = true
		
		if enemy_hand.has(card_to_play_array[2]):
			enemy_hand.remove(enemy_hand.find(card_to_play_array[2])) #remove the extra card from Enemy Hand
	
	#FUSE IF NEEDED
	var card_being_played : String = card_to_play_array[1] #by default, just the passed card. Fusion will change this
	var result_of_fusion = []
	if is_fusion_summon:
		result_of_fusion = GAME_LOGIC.fusion_list.check_for_fusion(card_to_play_array[1], card_to_play_array[2])
		card_being_played = result_of_fusion[0]
		
		#Add to the history if it's a successfull monster fusion
		if typeof(result_of_fusion[1]) == TYPE_BOOL and result_of_fusion[1] == true:
			get_node("../../side_menu").list_of_fusions_in_this_duel.append([card_to_play_array[1], card_to_play_array[2], result_of_fusion[0]])
		elif typeof(result_of_fusion[1]) == TYPE_ARRAY:
			var monster_involved = card_to_play_array[1]
			if CardList.card_list[card_to_play_array[1]].attribute in ["spell", "trap"]:
				monster_involved = card_to_play_array[2]
			get_node("../../side_menu").list_of_fusions_in_this_duel.append([card_to_play_array[1], card_to_play_array[2], monster_involved])
		
		#Animate the fusing of the two cards
		var fusion_timer : float = 0.8 #in seconds
		var fusion_start_pos_0 : Vector2 = Vector2(83+60, 80)
		var fusion_start_pos_1 : Vector2 = Vector2(856-60, 80)
		var fusion_final_pos : Vector2 = Vector2(475, 80)
		
		SoundControl.play_sound("poc_fusion1")
		
		$fusion_animation/fusion_order_0.rect_position = fusion_start_pos_0
		$fusion_animation/fusion_order_1.rect_position = fusion_start_pos_1
		$fusion_animation/fusion_order_0.update_card_information(card_to_play_array[1])
		$fusion_animation/fusion_order_1.update_card_information(card_to_play_array[2])
		$fusion_animation/fusion_order_0.show()
		$fusion_animation/fusion_order_1.show()
		$fusion_animation.show()
		$fusion_animation/tween_fusion.interpolate_property($fusion_animation/fusion_order_0, "rect_position", fusion_start_pos_0, fusion_final_pos, fusion_timer, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
		$fusion_animation/tween_fusion.interpolate_property($fusion_animation/fusion_order_0, "modulate", Color(1, 1, 1, 1), Color(10, 10, 10, 0.666), fusion_timer*0.9, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$fusion_animation/tween_fusion.interpolate_property($fusion_animation/fusion_order_1, "rect_position", fusion_start_pos_1, fusion_final_pos, fusion_timer, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
		$fusion_animation/tween_fusion.interpolate_property($fusion_animation/fusion_order_1, "modulate", Color(1, 1, 1, 1), Color(10, 10, 10, 0.666), fusion_timer*0.9, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$fusion_animation/tween_fusion.start()
		$enemy_timer.start(fusion_timer); yield($enemy_timer, "timeout")
		$fusion_animation/fusion_order_0.hide()
		$fusion_animation/fusion_order_1.hide()
		
		#Do the changes to the resulting card
		field_node_to_use.this_card_flags.fusion_type = "fusion"
		field_node_to_use.this_card_flags.is_facedown = false
		field_node_to_use.get_node("card_design/card_back").hide()
		if typeof(result_of_fusion[1]) == TYPE_ARRAY:
			field_node_to_use.this_card_flags.fusion_type = null
			field_node_to_use.this_card_flags.atk_up = result_of_fusion[1][0]
			field_node_to_use.this_card_flags.atk_up = result_of_fusion[1][1]
		
		#Animate the showing of the result
		var fusion_result_start_size : Vector2 = Vector2(0.7, 0.7)
		var fusion_result_final_size : Vector2 = Vector2(0.9, 0.9)
		
		$fusion_animation/fusion_result_card.modulate = Color(10, 10, 10)
		$fusion_animation/fusion_result_card.rect_scale = fusion_result_start_size
		$fusion_animation/fusion_result_card.this_card_flags = field_node_to_use.this_card_flags
		$fusion_animation/fusion_result_card.update_card_information(card_being_played)
		$fusion_animation/fusion_result_card.show()
		SoundControl.play_sound("poc_fusion2")
		$fusion_animation/tween_fusion.interpolate_property($fusion_animation/fusion_result_card, "modulate", Color(10, 10, 10), Color(1, 1, 1), fusion_timer*0.8, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$fusion_animation/tween_fusion.interpolate_property($fusion_animation/fusion_result_card, "rect_scale", fusion_result_start_size, fusion_result_final_size, fusion_timer*0.8, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$fusion_animation/tween_fusion.start()
		$enemy_timer.start(fusion_timer*1.5); yield($enemy_timer, "timeout")
		$fusion_animation/fusion_result_card.hide()
		$fusion_animation.hide()
	
	#Update node on the field with the new card's info
	field_node_to_use.this_card_id = card_being_played
	
	match CardList.card_list[field_node_to_use.this_card_id].attribute:
		"spell": #Spells are placed face up so they can insta-activate
			field_node_to_use.this_card_flags.is_facedown = false
		"trap": #Traps are always placed face down
			field_node_to_use.this_card_flags.is_facedown = true
		_: #Monsters will depend
			if is_fusion_summon: #On fusion, force face up
				field_node_to_use.this_card_flags.is_facedown = false
			else: #Not fusions, it depends
				var force_facedown = false
				if CardList.card_list[field_node_to_use.this_card_id].effect.size() > 0 and CardList.card_list[field_node_to_use.this_card_id].effect[0] == "on_flip":
					force_facedown = true
				elif CardList.card_list[field_node_to_use.this_card_id].def > CardList.card_list[field_node_to_use.this_card_id].atk:
					force_facedown = true
				elif CardList.card_list[field_node_to_use.this_card_id].effect.size() == 0:
					force_facedown = true
				if CardList.card_list[field_node_to_use.this_card_id].effect.size() > 0 and CardList.card_list[field_node_to_use.this_card_id].effect[0] in ["on_summon"]:
					force_facedown = false
				
				if force_facedown == true:
					field_node_to_use.this_card_flags.is_facedown = true
				else:
					field_node_to_use.this_card_flags.is_facedown = false
	
	#Finally show the card on the field
	field_node_to_use.update_card_information(field_node_to_use.this_card_id)
	field_node_to_use.show()
	
	SoundControl.play_sound("poc_move")
	
	#Check if this card will get a field bonus
	var field_name : String
	var field_element_colors = {
		"fire":  Color("ff4a4a"),
		"earth": Color("0ca528"),
		"water": Color("1c68ff"),
		"wind":  Color("4dedff"),
		"dark":  Color("5100ff"),
		"light": Color("ffef00"),
	}
	
	for attribute in field_element_colors.keys():
		var color = field_element_colors[attribute]
		if GAME_LOGIC.get_parent().get_node("duel_field/enemy_side_zones").self_modulate == color:
			field_name = attribute
			break
	
	get_node("../effects").field_bonus(field_name)
	
	#Update UI with the played card information, if card isn't facedown
	if field_node_to_use.this_card_flags.is_facedown == false:
		get_node("../../").update_user_interface(field_node_to_use)
	else: #Put stuff on 'card_info_box' hidden
		get_node("../../user_interface/card_info_box/colored_bar").hide()
		get_node("../../user_interface/card_info_box/card_name").hide()
		get_node("../../user_interface/card_info_box/atk_def").hide()
		get_node("../../user_interface/card_info_box/extra_icons").hide()
		get_node("../../user_interface/card_info_box/card_text").hide()
	
	#If it's not facedown, check if it has an effect to activate
	if field_node_to_use.this_card_flags.is_facedown == false and CardList.card_list[field_node_to_use.this_card_id].effect.size() > 0:
		GAME_LOGIC.effect_activation(field_node_to_use, "on_summon")
		yield(get_node("../effects"), "effect_fully_executed")
	
	#Move to enemy's next phase
	enemy_main_phase()

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ENEMY BATTLE LOGIC IS A LOOP THAT HAPPENS DURING IT'S MAIN PHASAE
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
func enemy_main_phase():
	GAME_LOGIC.GAME_PHASE = "enemy_main_phase"
	
	var list_of_player_monsters = get_field_monsters_array("player") #returns already sorted by ATK
	var list_of_COM_monsters = get_field_monsters_array("enemy") ##returns already sorted by ATK
	
	#First check: for monsters that can Direct Attack and would Finish the Duel, or are very Strong and it's valuable to Direct Attack
	for monster in list_of_COM_monsters:
		if CardList.card_list[monster.this_card_id].effect.size() > 1 and CardList.card_list[monster.this_card_id].effect[1] in ["can_direct", "toon"]:
			var player_LP = int(get_node("../../user_interface/top_info_box/player_info/lifepoints").text)
			var monster_atk_on_field = int(monster.get_node("card_design/monster_features/atk_def/atk").text)
			if  monster_atk_on_field >= player_LP or monster_atk_on_field >= 2500:
				COM_try_to_attack_with_monster(monster, null) #passing the target as Null makes the attack a Direct Attack
				yield(self, "after_try_move_ahead")
	
	for _i in range(2): #loops 2 times, just to make sure no one is left behind
		#Update the lists
		list_of_player_monsters = get_field_monsters_array("player")
		list_of_COM_monsters = get_field_monsters_array("enemy")
		
		#Second check: general COM monsters that can battle
		var COM_monsters_available_for_battle : Array = []
		for monster in list_of_COM_monsters:
			if monster.this_card_flags.has_battled == false:
				COM_monsters_available_for_battle.append(monster)
		
		#if COM's strongest can beat Player Strongest, do the checks in inverse order for more final damage. It makes sense, belive me!
		if list_of_player_monsters.size() > 0 and COM_monsters_available_for_battle.size() > 0: #Both sides have monsters to battle
			if int(COM_monsters_available_for_battle[0].get_node("card_design/monster_features/atk_def/atk").text) > int(list_of_player_monsters[0].get_node("card_design/monster_features/atk_def/atk").text):
				COM_monsters_available_for_battle.invert() #Reverse sorted by ATK, so COM looks for the first monster ENOUGH to attack
			
			for target_monster in list_of_player_monsters:
				#Update the lists
				list_of_player_monsters = get_field_monsters_array("player")
				list_of_COM_monsters = get_field_monsters_array("enemy")
				
				if list_of_player_monsters.size() == 0:
					break
				
				var stat_of_target : int =  int(target_monster.get_node("card_design/monster_features/atk_def/atk").text)
				if target_monster.this_card_flags.is_defense_position:
					stat_of_target = int(target_monster.get_node("card_design/monster_features/atk_def/def").text)
				if target_monster.this_card_flags.is_facedown:
					stat_of_target = 900 #arbitrary value just so COM doesn't know what the facedown monster actually is
				
				#Catch the case of COM being baited by the third or latter monster
				if list_of_player_monsters.find(target_monster) >= 2:
					#print("Index is ", list_of_player_monsters.find(target_monster), " should abort battle.")
					continue #'continue' skips this loop, aborting the battle with this monster
				
				for COM_attacker in COM_monsters_available_for_battle:
					if COM_monsters_available_for_battle.size() == 0:
						break
					
					#Catch the case of Player's monster being indestructible
					if CardList.card_list[target_monster.this_card_id].effect.size() > 1 and CardList.card_list[target_monster.this_card_id].effect[1] == "cant_die" and target_monster.this_card_flags.is_defense_position == true:
						if CardList.card_list[target_monster.this_card_id].effect.size() > 2 and CardList.card_list[COM_attacker.this_card_id].attribute == CardList.card_list[target_monster.this_card_id].effect[2]:
							#If it matches the exception some of those have, ignore
							pass
						elif CardList.card_list[COM_attacker.this_card_id].effect.size() > 1 and CardList.card_list[COM_attacker.this_card_id].effect[1] == "piercing":
							#If com has Piercing, go for the attack
							pass
						else:
							continue #'continue' skips this loop, aborting the battle with this monster
					
					#Catch the case of COM not having enough LP to justify attacking with monsters that cost it
					if CardList.card_list[COM_attacker.this_card_id].effect.size() > 1 and CardList.card_list[COM_attacker.this_card_id].effect[1] == "lifepoint_cost":
						if int(get_node("../../user_interface/top_info_box/com_info/lifepoints").text) <= 3000: #Arbitrary min LP value to not excuse the attack
							break
					
					var atk_of_COM = int(COM_attacker.get_node("card_design/monster_features/atk_def/atk").text)
					
					#Correct the math for monsters that Debuff the opponent when they attack
					if CardList.card_list[COM_attacker.this_card_id].effect.size() > 1 and CardList.card_list[COM_attacker.this_card_id].effect[1] in ["rocket_warrior", "injection_fairy"]:
						if CardList.card_list[COM_attacker.this_card_id].effect[1] == "rocket_warrior" and stat_of_target == int(target_monster.get_node("card_design/monster_features/atk_def/atk").text):
							stat_of_target -= 500
						elif CardList.card_list[COM_attacker.this_card_id].effect[1] == "injection_fairy" and int(get_node("../../user_interface/top_info_box/com_info/lifepoints").text) > 2000:
							stat_of_target -= 3000
					#Monsters with mutual banish will ignore opponent's atk value
					if CardList.card_list[COM_attacker.this_card_id].effect.size() > 1 and CardList.card_list[COM_attacker.this_card_id].effect[1] == "mutual_banish":
						stat_of_target = 0
					
					if atk_of_COM > stat_of_target:
						var _did_battle = COM_try_to_attack_with_monster(COM_attacker, target_monster)
						#Wait for the battle end signal before proceeding
						if not COM_attacker.is_visible() or not target_monster.is_visible():
							pass #preventing yield that will never return
						else:
							yield(self, "after_try_move_ahead")
						
						COM_monsters_available_for_battle.erase(COM_attacker)
						
						#Animation of de-scaling the card when it's loop is finished
						var scaled_back_size = Vector2(GAME_LOGIC.atk_orientation_x_scale, GAME_LOGIC.atk_orientation_y_scale)
						var scale_timer : float = 0.2 #in seconds
						
						COM_attacker.get_node("card_self_tween").interpolate_property(COM_attacker, "rect_scale", COM_attacker.rect_scale, scaled_back_size, scale_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
						COM_attacker.get_node("card_self_tween").start()
						yield(COM_attacker.get_node("card_self_tween"), "tween_all_completed")
			
		else: #At least one of the sides don't have monsters to battle
			if COM_monsters_available_for_battle.size() != 0: #if COM don't have any monsters there is nothing to do, if it does, Direct Attacks!
				for monster in list_of_COM_monsters:
					#Update the lists
					list_of_COM_monsters = get_field_monsters_array("enemy")
					
					#This was implemented mostly because of 'Cloning' Token being ignored by COM. Will probably be useful for any time player summons a new monster mid-battle.
					var recheck_player_monsters = get_field_monsters_array("player")
					if recheck_player_monsters.size() != 0:
						print("Safe Recheck found a monster on player side, restarting enemy main phase just to be safe.")
						enemy_main_phase()
						return
					
					if COM_monsters_available_for_battle.size() == 0 or list_of_COM_monsters.size() == 0:
						break
					
					#Catch the case of COM not having enough LP to justify attacking with monsters that cost it
					if CardList.card_list[monster.this_card_id].effect.size() > 1 and CardList.card_list[monster.this_card_id].effect[1] == "lifepoint_cost":
						if int(get_node("../../user_interface/top_info_box/com_info/lifepoints").text) <= 1500: #Arbitrary min LP value to not excuse the attack
							break
					
					if monster.this_card_flags.has_battled == false:
						#Timer for better workflow before each monster iteraction
						var battle_timer : float = 1.0
						$enemy_timer.start(battle_timer*0.8); yield($enemy_timer, "timeout")
						
						if monster.this_card_flags.is_defense_position == true and int(monster.get_node("card_design/monster_features/atk_def/atk").text) > 0:
							monster.toggle_battle_position()
							$enemy_timer.start(battle_timer/2); yield($enemy_timer, "timeout")
						
						GAME_LOGIC.do_direct_attack(monster)
						if monster.is_visible():
							yield(get_node("../"), "battle_finished")
	
	#Final Check: For any monsters that haven't attacked yet. Maybe they can now, maybe they can be set to Defense
	list_of_COM_monsters = get_field_monsters_array("enemy")
	for monster in list_of_COM_monsters:
		#Update the lists
		list_of_COM_monsters = get_field_monsters_array("enemy")
		
		if list_of_COM_monsters.size() == 0:
			break
		
		if monster.this_card_flags.has_battled == false:
			#Catch a multiple attacker that hasn't attacked yet
			if CardList.card_list[monster.this_card_id].effect.size() > 1 and CardList.card_list[monster.this_card_id].effect[1] == "multiple_attacker":
				print(monster, " This card probably could've attacked a second time.")
			
			#Change it to Defense position if it's favorable
			if monster.this_card_flags.is_defense_position == false:
				#Timer for better workflow before each monster iteraction
				var battle_timer : float = 1.0
				$enemy_timer.start(battle_timer*0.8); yield($enemy_timer, "timeout")
				
				var com_atk = int(monster.get_node("card_design/monster_features/atk_def/atk").text)
				var com_def = int(monster.get_node("card_design/monster_features/atk_def/def").text)
				
				var player_highest_atk_on_field = 0
				var get_current_player_list = get_field_monsters_array("player")
				if get_current_player_list.size() > 0:
					player_highest_atk_on_field = int(get_current_player_list[0].get_node("card_design/monster_features/atk_def/atk").text)
				
				if player_highest_atk_on_field - com_atk >= int(get_node("../../user_interface/top_info_box/com_info/lifepoints").text) or player_highest_atk_on_field > com_atk or com_def > player_highest_atk_on_field or com_def > com_atk or com_atk < 1000:
					if com_def != 0:
						monster.toggle_battle_position()
						monster.this_card_flags.has_battled = true
	
	#After everything, go to End Phase
	enemy_end_turn()

#----- The trying to battle logic
func COM_try_to_attack_with_monster(COM_attacking_monster : Node, player_defending_monster : Node): #Returns 'did_battle' : bool for waiting time reasons
	if not COM_attacking_monster.is_visible():
		emit_signal("after_try_move_ahead")
		return false
	if player_defending_monster != null and not player_defending_monster.is_visible():
		emit_signal("after_try_move_ahead")
		return false
	if COM_attacking_monster.this_card_flags.has_battled == true:
		emit_signal("after_try_move_ahead")
		return false
	
	#Update bottom bar so it reflects the current "active" monster
	if COM_attacking_monster.this_card_flags.is_facedown == false:
		get_node("../../").update_user_interface(COM_attacking_monster)
	
	#Animate the card to indicate which one is being interacted this turn
	var scaled_back_size = Vector2(GAME_LOGIC.atk_orientation_x_scale, GAME_LOGIC.atk_orientation_y_scale)
	var scale_up_size = Vector2(scaled_back_size[0]*1.05, scaled_back_size[1]*1.05)
	var scale_timer : float = 0.2 #in seconds
	COM_attacking_monster.get_node("card_self_tween").interpolate_property(COM_attacking_monster, "rect_scale", COM_attacking_monster.rect_scale, scale_up_size, scale_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	COM_attacking_monster.get_node("card_self_tween").start()
	yield(COM_attacking_monster.get_node("card_self_tween"), "tween_all_completed")
	
	#Timer for better workflow before each monster iteraction
	var battle_timer : float = 1.0
	$enemy_timer.start(battle_timer*0.8); yield($enemy_timer, "timeout")
	
	#Check for fear of Spelltraps, independent if it's battling a monster or direct attacking
	var fear_of_spelltraps : float
	var player_has_spelltrap = false
	for i in range(5):
		if get_node("../../duel_field/player_side_zones/spelltrap_" + String(i)).is_visible():
			player_has_spelltrap = true
			break
	if player_has_spelltrap:
		if int(COM_attacking_monster.get_node("card_design/monster_features/atk_def/atk").text) >= 3000: fear_of_spelltraps = 0.6
		elif int(COM_attacking_monster.get_node("card_design/monster_features/atk_def/atk").text) >= 2000: fear_of_spelltraps = 0.4
		elif int(COM_attacking_monster.get_node("card_design/monster_features/atk_def/atk").text) >= 1000: fear_of_spelltraps = 0.2
		else: fear_of_spelltraps = 0.1
		
		if CardList.card_list[COM_attacking_monster.this_card_id].effect.size() > 1 and CardList.card_list[COM_attacking_monster.this_card_id].effect[1] == "ignore_spelltrap":
			fear_of_spelltraps = 0
		
		randomize()
		var random_roll = randf()
		if random_roll <= fear_of_spelltraps:
			emit_signal("after_try_move_ahead")
			return false #The monster will not attack because it fears a set Trap card
	
	#Check if it's a direct attack or battle between monsters
	if player_defending_monster == null: 
		#Direct Attacks
		if CardList.card_list[COM_attacking_monster.this_card_id].effect.size() > 1 and CardList.card_list[COM_attacking_monster.this_card_id].effect[1] == "toon":
			if int(get_node("../../user_interface/top_info_box/com_info/lifepoints").text) <= 500: 
				emit_signal("after_try_move_ahead")
				return false #Not enough for Toon to attack diretly without COM dying itself
		
		if COM_attacking_monster.this_card_flags.is_defense_position == true and int(COM_attacking_monster.get_node("card_design/monster_features/atk_def/atk").text) > 0:
			COM_attacking_monster.toggle_battle_position()
			$enemy_timer.start(battle_timer/2); yield($enemy_timer, "timeout")
		GAME_LOGIC.do_direct_attack(COM_attacking_monster)
		yield(get_node("../"), "battle_finished")
		emit_signal("after_try_move_ahead")
		return true
		
	elif player_defending_monster != null: 
		#Fear for facedown monsters
		var fear_of_facedown : float
		if player_defending_monster.this_card_flags.is_facedown:
			if int(COM_attacking_monster.get_node("card_design/monster_features/atk_def/atk").text) >= 3000: fear_of_facedown = 0.3 #fears for flip destruction, but only a little
			elif int(COM_attacking_monster.get_node("card_design/monster_features/atk_def/atk").text) >= 2000: fear_of_facedown = 0.4 #almost fearless
			elif int(COM_attacking_monster.get_node("card_design/monster_features/atk_def/atk").text) >= 1000: fear_of_facedown = 0.6 #kinda fear high defense
			else: fear_of_facedown = 0.9 #fears for high defense
			
			if CardList.card_list[COM_attacking_monster.this_card_id].effect.size() > 1 and CardList.card_list[COM_attacking_monster.this_card_id].effect[1] == "anti_flip":
				var fear_reduce_factor : float = 0.3
				fear_of_facedown = clamp(fear_of_facedown - fear_reduce_factor, 0, 1) #don't necessarily go to 0 because it can still somewhat fear a High Defense
			if CardList.card_list[COM_attacking_monster.this_card_id].effect.size() > 1 and CardList.card_list[COM_attacking_monster.this_card_id].effect[1] == "mutual_banish":
				fear_of_facedown = 0 #it will kill anything it touches anyway, so no fear
			
			randomize()
			var random_roll = randf()
			if random_roll <= fear_of_facedown:
				emit_signal("after_try_move_ahead")
				return false #The monster will not attack because it fears a face down monster (either effect or high def)
		
		#Correct math for debuff monsters
		if CardList.card_list[player_defending_monster.this_card_id].effect.size() > 1 and CardList.card_list[player_defending_monster.this_card_id].effect[1] == "debuff":
			var com_atk_debuffed = int(COM_attacking_monster.get_node("card_design/monster_features/atk_def/atk").text) - CardList.card_list[player_defending_monster.this_card_id].effect[2]
			var player_defending_monster_stat = int(player_defending_monster.get_node("card_design/monster_features/atk_def/atk").text)
			if player_defending_monster.this_card_flags.is_defense_position:
				player_defending_monster_stat = int(player_defending_monster.get_node("card_design/monster_features/atk_def/def").text)
				
			if com_atk_debuffed < player_defending_monster_stat:
				emit_signal("after_try_move_ahead")
				return false #chicken out of combat
		
		#If it didn't return out of combat already, finally do the battle
		if COM_attacking_monster.this_card_flags.is_defense_position == true and int(COM_attacking_monster.get_node("card_design/monster_features/atk_def/atk").text) > 0:
			COM_attacking_monster.toggle_battle_position()
			$enemy_timer.start(battle_timer/2); yield($enemy_timer, "timeout")
		GAME_LOGIC.do_battle(COM_attacking_monster, player_defending_monster)
		yield(get_node("../"), "battle_finished")
		emit_signal("after_try_move_ahead")
		return true

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# END OF COM'S TURN, RESETTING WHATEVER NEEDS TO BE RESETTED AND SO ON
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
func enemy_end_turn():
	#Wait some time before actually ending the turn for better game flow
	$enemy_timer.start(1); yield($enemy_timer, "timeout")
	
	if not get_node("../../reward_scene").is_visible():
		SoundControl.play_sound("poc_turn_end")
	
	#At the end of the turn, remove the darken layer from the monsters that battled this turn
	for i in range(5):
		var this_i_monster = get_node("../../duel_field/enemy_side_zones/monster_" + String(i))
		this_i_monster.get_node("card_design/darken_card").hide()
		
		if CardList.card_list[this_i_monster.this_card_id].effect.size() > 1 and typeof(CardList.card_list[this_i_monster.this_card_id].effect[1]) == TYPE_STRING and CardList.card_list[this_i_monster.this_card_id].effect[1] == "multiple_attacker":
			this_i_monster.this_card_flags.multiple_attacks = 0
	
	#Move camera back to player's side of the field
	if get_node("../../duel_field").position == get_node("../../").enemy_field_camera_position:
		get_node("../../").change_field_view()
	
	#End enemy's turn, going back to player's turn
	GAME_LOGIC.get_node("player_logic").start_player_turn()
