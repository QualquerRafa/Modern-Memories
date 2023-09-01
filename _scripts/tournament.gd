extends Node2D

var tournament_progression : Array = [] #green, blue, purple, red, gold

func _ready():
	#Animate the transition when starting this scene
	$scene_transitioner.entering_this_scene()
	yield(get_tree().create_timer(0.5), "timeout")
	
	#If player is entering this scene after a duel it will have PlayerData.tournament_progression set to it's last value, so recover it. Otherwise just start the green tier.
	if PlayerData.tournament_last_progression_saved == "":
		#Get the first batch of duelists to start the tournament
		update_duelist_boxes("green")
	else:
		tournament_progression.append(PlayerData.tournament_last_progression_saved)
	
	#The function bellow handles everything
	tournament_flow()

#---------------------------------------------------------------------------------------------------
# Tournament related Functions
#---------------------------------------------------------------------------------------------------
func get_tournament_competitors(color_tier : String):
	var npc_decks_gd = preload("res://_scripts/npc_decks.gd").new()
	var pool_of_npcs : Array = npc_decks_gd.list_of_decks.keys()
	var prohibited_duelists = ["tenma", "nitemare", "nightshroud"]
	
	#Remove some unwanted duelists from the tournament
	for prohibited in prohibited_duelists:
		pool_of_npcs.erase(prohibited)
	
	var tournament_selected_competitors : Array = []
	match color_tier:
		"green":
			#Pick 15 of the available NPCs as initial opponents for the tournament
			for _i in range(15):
				randomize()
				var random_npc_id = randi()%pool_of_npcs.size()
				tournament_selected_competitors.append(pool_of_npcs[random_npc_id])
				pool_of_npcs.remove(random_npc_id)
			
			#Also add the player to the list and shuffle it
			tournament_selected_competitors.append("player")
			randomize()
			tournament_selected_competitors.shuffle()
		
		"blue", "purple", "red", "gold":
			#Pick 2^color_index of the previous (NPCs + player)
			var color_index = ["gold", "red", "purple", "blue"].find(color_tier)
			
			var colors = ["green", "blue", "purple", "red", "gold"]
			var previous_tier = colors[colors.find(color_tier) -1]
			var previous_duelists = PlayerData.tournament_competitors_saved[previous_tier].duplicate()
			
			for _i in range(pow(2, color_index)):
				var duelist_0 = previous_duelists[0]
				var duelist_1 = previous_duelists[1]
				
				var random_winner : String
				if not duelist_0 == "player" and not duelist_1 == "player":
					randomize()
					random_winner = previous_duelists[randi()%2] #0 or 1
				else:
					random_winner = "player"
				
				tournament_selected_competitors.append(random_winner)
				previous_duelists.pop_front() #remove 0
				previous_duelists.pop_front() #remove 1 that is now 0
	
	#Save in player data the generated competitors for that color_tier
	PlayerData.tournament_competitors_saved[color_tier] = tournament_selected_competitors
	#print("SAVED: ", PlayerData.tournament_competitors_saved)

func update_duelist_boxes(box_color : String):
	#Get the faces for this box_color
	get_tournament_competitors(box_color)
	
	#Black out the tiers above it, grey out the losers bellow it
	var tier_colors = ["green", "blue", "purple", "red", "gold"]
	
	#Update the duelist faces in all the tiers
	for color in tier_colors:
		var saved_competitors_in_color = PlayerData.tournament_competitors_saved[color]
		for i in range(saved_competitors_in_color.size()):
			var duelist_face_node = get_node("tournament_brackets/duelists_faces/" + color + "/face" + String(i+1))
			duelist_face_node.texture = load("res://_resources/character_faces/" + saved_competitors_in_color[i] + "0.png")
	
	#Black out tiers above
	for i in range(tier_colors.find(box_color) + 1, tier_colors.size()):
		var color_to_black_out = tier_colors[i]
		for j in range(get_node("tournament_brackets/duelists_faces/" + color_to_black_out).get_child_count()):
			get_node("tournament_brackets/duelists_faces/" + color_to_black_out).get_child(j).texture = null
	
	#Grey out the previous tiers losers
	
	#Estou no tier box_color. Se um duelista do tier anterior não estiver nesse, grey out
	for color in tier_colors:
		if tier_colors.find(color) > tier_colors.find(box_color) or color == "green": continue #ignore the loop for colors above current tier
		var previous_tier = tier_colors[tier_colors.find(color) -1]
		for duelist_face in get_node("tournament_brackets/duelists_faces/" + previous_tier).get_children():
			var duelist_name = duelist_face.texture.resource_path.split("/")[-1].trim_suffix("0.png")
			if not duelist_name in PlayerData.tournament_competitors_saved[color]:
				duelist_face.self_modulate = Color(1,1,1, 0.3)
	
#	for i in range(0, tier_colors.find(box_color) +1):
#		var previous_tier = tier_colors[tier_colors.find(box_color) - i]
#		for duelist_face in get_node("tournament_brackets/duelists_faces/" + previous_tier).get_children():
#			var duelist_name = duelist_face.texture.resource_path.split("/")[-1].trim_suffix("0.png")
#			if not duelist_name in PlayerData.tournament_competitors_saved[box_color]:
#				duelist_face.self_modulate = Color(1,1,1, 0.3)

func toggle_tournament_brackets_visibility():
	var animation_timer = 0.5
	if not $tournament_brackets.is_visible():
		#Animate the brackets being shown
		$tournament_brackets.modulate = Color(1,1,1, 0) #transparent
		$tournament_brackets.show()
		$tournament_tween.interpolate_property($tournament_brackets, "modulate", Color(1,1,1, 0), Color(1,1,1, 1), animation_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$tournament_tween.start()
		
		$background_art/blurred_bg.modulate = Color(1,1,1, 0) #transparent
		$background_art/blurred_bg.show()
		$background_art/background_tween.interpolate_property($background_art/blurred_bg, "modulate", Color(1,1,1, 0), Color(1,1,1, 1), animation_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$background_art/background_tween.start()
		
		yield($tournament_tween, "tween_completed")
		
	else:
		#Animate the brackets disappearing
		$tournament_tween.interpolate_property($tournament_brackets, "modulate", Color(1,1,1, 1), Color(1,1,1, 0), animation_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$tournament_tween.start()
		
		$background_art/background_tween.interpolate_property($background_art/blurred_bg, "modulate", Color(1,1,1, 1), Color(1,1,1, 0), animation_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$background_art/background_tween.start()
		
		yield($tournament_tween, "tween_completed")
		
		$tournament_brackets.hide()
		$background_art/blurred_bg.hide()

func get_opponent_name(current_tier : String):
	var tournament_competitors = PlayerData.tournament_competitors_saved[current_tier]
	var opponent_name : String
	
	var player_index = tournament_competitors.find("player")
	if player_index%2 == 0:
		opponent_name = tournament_competitors[player_index + 1]
	else:
		opponent_name = tournament_competitors[player_index - 1]
	
	return opponent_name

#---------------------------------------------------------------------------------------------------
# Dialog related functions, in pair with $dialogue_scene (characters_dialogs.gd)
#---------------------------------------------------------------------------------------------------
func _on_dialogue_scene_dialogue_box_clicked():
	tournament_flow()

func tournament_flow():
	#Catch when player loses a duel
	if PlayerData.last_duel_result == "lose" and tournament_progression.size() > 0 and tournament_progression[-1] != "next_click_returns_to_main_screen":
		var dialogue_to_show = $dialogue_scene.get_dialog("generic", "duel_victorious")
		$dialogue_scene.update_screen_dialog(PlayerData.tournament_last_duelist_saved, dialogue_to_show[1])
		tournament_progression.append("next_click_returns_to_main_screen")
		return
	
	#First message
	if tournament_progression.size() == 0:
		var dialogue_to_show = $dialogue_scene.get_dialog("roland", "tournament_1")
		$dialogue_scene.update_screen_dialog(dialogue_to_show[0], dialogue_to_show[1])
		tournament_progression.append("tournament_1")
		return #escape to not glitch with rest of the function
	
	#Basic logic for the opening messages. Always look at the last registered one and proceed from that
	if tournament_progression[-1] == "tournament_1":  #show the message after this one
		var dialogue_to_show = $dialogue_scene.get_dialog("roland", "tournament_2")
		$dialogue_scene.update_screen_dialog(dialogue_to_show[0], dialogue_to_show[1])
		tournament_progression.append("tournament_2")
		return #escape to not glitch with rest of the function
	elif tournament_progression[-1] == "tournament_2":#show the message after this one
		var dialogue_to_show = $dialogue_scene.get_dialog("roland", "tournament_3")
		$dialogue_scene.update_screen_dialog(dialogue_to_show[0], dialogue_to_show[1])
		tournament_progression.append("tournament_3")
		return #escape to not glitch with rest of the function
	elif tournament_progression[-1] == "tournament_3":
		$dialogue_scene.empty_dialog_box()
		toggle_tournament_brackets_visibility()
		var dialogue_to_show = $dialogue_scene.get_dialog("roland", "tournament_green_tier")
		$dialogue_scene.update_screen_dialog(dialogue_to_show[0], dialogue_to_show[1], true)
		tournament_progression.append("tournament_green_tier")
		return #escape to not glitch with rest of the function
	
	#Tournament special logic that will loop through the colors doing basically the same thing
	var tier_colors = ["green", "blue", "purple", "red", "gold"]
	var current_color : String
	if PlayerData.tournament_last_progression_saved == "":
		#If the is no record of last progression, start with green
		current_color = "green"
	else:
		if PlayerData.tournament_last_progression_saved.find("after_duel") != -1:
			current_color = PlayerData.tournament_last_progression_saved.split("_")[0]  #this saved string comes in the format of "green_tier_after_duel"
		else:
			current_color = PlayerData.tournament_last_progression_saved.split("_")[1] #this saved string comes in the format of "tournament_blue_tier"
	
	#Special check for gold color
	if current_color == "gold" and not tournament_progression.has("gold_tier"):
		tournament_progression.append("gold_tier")
	
	#LOOP
	if tournament_progression[-1] == "tournament_"+ current_color +"_tier":
		#Get the opponent's name and use it to show the correct picure, dialogue and start the duel
		var opponent_name = get_opponent_name(current_color)
		
		toggle_tournament_brackets_visibility()
		#yield(get_tree().create_timer(0.2), "timeout")
		
		var dialogue_to_show = $dialogue_scene.get_dialog("generic", "pre_duel")
		$dialogue_scene.update_screen_dialog(opponent_name, dialogue_to_show[1])
		tournament_progression.append(current_color + "_tier_duel")
		
	elif tournament_progression[-1] == current_color + "_tier_duel":
		var opponent_name = get_opponent_name(current_color)
		PlayerData.going_to_duel = opponent_name
		
		#Save stuff on PlayerData so it can be recovered once the duel is over
		PlayerData.tournament_last_progression_saved = current_color + "_tier_after_duel"
		PlayerData.tournament_last_duelist_saved = opponent_name
		
		#Go to the duel
		PlayerData.scene_to_return_after_duel = "tournament_scene"
		$scene_transitioner.scene_transition("deck_building")
		
	elif tournament_progression[-1] == current_color + "_tier_after_duel":
		var last_opponent_name = PlayerData.tournament_last_duelist_saved
		var duel_result_string : String = ""
		
		#Get the correct dialogue for the NPC based on if the player has won or lost their duel
		if PlayerData.last_duel_result == "win":
			duel_result_string = "duel_defeated"
		else:
			duel_result_string = "duel_victorious"
		
		var dialogue_to_show = $dialogue_scene.get_dialog("generic", duel_result_string)
		$dialogue_scene.update_screen_dialog(last_opponent_name, dialogue_to_show[1])
		tournament_progression.append("move_next_duel")
		
	elif tournament_progression[-1] == "move_next_duel":
		var next_color = tier_colors[tier_colors.find(current_color) + 1]
		update_duelist_boxes(next_color)
		toggle_tournament_brackets_visibility()
		
		var roland_line = "tournament_move_tier"
		if current_color == "purple":
			roland_line = "tournament_final_tier"
		elif current_color == "red":
			roland_line = "tournament_champion"
		
		var dialogue_to_show = $dialogue_scene.get_dialog("roland", roland_line)
		$dialogue_scene.update_screen_dialog(dialogue_to_show[0], dialogue_to_show[1], true)
		tournament_progression.append("wait_for_player_input")
		
	elif tournament_progression[-1] == "wait_for_player_input":
		var next_color = tier_colors[tier_colors.find(current_color) + 1]
		tournament_progression.append("tournament_"+ next_color +"_tier")
		PlayerData.tournament_last_progression_saved = "tournament_"+ next_color +"_tier"
		
		#tournament_flow()
	
	#Dealing with the Golden Tier separately since there is no tier above it
	if tournament_progression[-1] == "gold_tier":
		var dialogue_to_show = $dialogue_scene.get_dialog("roland", "tournament_hijack")
		$dialogue_scene.update_screen_dialog("?????", dialogue_to_show[1], true)
		tournament_progression.append("loser_rematch")
		
		#Give the final reward of the Tournament
		PlayerData.player_starchips += 25
		#print("Added 25 starchips, total is ", PlayerData.player_starchips)
		
	elif tournament_progression[-1] == "loser_rematch":
		toggle_tournament_brackets_visibility()
		PlayerData.tournament_competitors_saved.green.erase("player")
		
		var duelists_available_for_rematch = []
		for duelist in PlayerData.tournament_competitors_saved.green:
			if not duelist in PlayerData.tournament_competitors_saved.red:
				duelists_available_for_rematch.append(duelist)
		var duelist_to_rematch = duelists_available_for_rematch[randi()%duelists_available_for_rematch.size()]
		
		var dialogue_to_show = $dialogue_scene.get_dialog("generic", "tournament_rematch")
		$dialogue_scene.update_screen_dialog(duelist_to_rematch, dialogue_to_show[1])
		tournament_progression.append("rematch_duel")
		
	elif tournament_progression[-1] == "rematch_duel":
		PlayerData.going_to_duel = $dialogue_scene/dialogue_box/character_name.get_text().to_lower()
		
		#Save stuff on PlayerData so it can be recovered once the duel is over
		PlayerData.tournament_last_progression_saved = "tournament_rematch_end"
		PlayerData.tournament_last_duelist_saved = $dialogue_scene/dialogue_box/character_name.get_text().to_lower()
		
		#Go to the duel
		PlayerData.scene_to_return_after_duel = "tournament_scene"
		$scene_transitioner.scene_transition("deck_building")
		
	elif tournament_progression[-1] == "tournament_rematch_end":
		var last_opponent_name = PlayerData.tournament_last_duelist_saved
		var duel_result_string : String = ""
		
		#Get the correct dialogue for the NPC based on if the player has won or lost their duel
		if PlayerData.last_duel_result == "win":
			duel_result_string = "duel_defeated"
		else:
			duel_result_string = "duel_victorious"
		
		var dialogue_to_show = $dialogue_scene.get_dialog("generic", duel_result_string)
		$dialogue_scene.update_screen_dialog(last_opponent_name, dialogue_to_show[1])
		tournament_progression.append("tournament_end")
		
	elif tournament_progression[-1] == "tournament_end":
		var dialogue_to_show = $dialogue_scene.get_dialog("roland", "tournament_end")
		$dialogue_scene.update_screen_dialog(dialogue_to_show[0], dialogue_to_show[1])
		tournament_progression.append("next_click_returns_to_main_screen")
		
	elif tournament_progression[-1] == "next_click_returns_to_main_screen":
		#Erase everything related to this Tournament duel
		PlayerData.scene_to_return_after_duel = ""
		PlayerData.going_to_duel = ""
		
		PlayerData.tournament_last_progression_saved = ""
		PlayerData.tournament_competitors_saved = {"green" : [], "blue" : [], "purple" : [], "red" : [], "gold" : []}
		PlayerData.tournament_last_duelist_saved = ""
		
		if PlayerData.last_duel_result != "lose":
			PlayerData.last_duel_result = ""
			$scene_transitioner.scene_transition("main_menu")
		else:
			PlayerData.last_duel_result = ""
			$scene_transitioner.scene_transition("game_over")
	




