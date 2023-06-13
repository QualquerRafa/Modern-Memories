extends Node2D

var tournament_progression : Array = [] #green, blue, purple, red, gold
var tournament_competitors : Array = []

func _ready():
	#Animate the transition when starting this scene
	$scene_transitioner.entering_this_scene()
	yield(get_tree().create_timer(0.5), "timeout")
	
	#The function bellow handles everything
	tournament_flow()
	update_duelist_boxes("green", get_tournament_competitors("green"))

#---------------------------------------------------------------------------------------------------
# Tournament related Functions
#---------------------------------------------------------------------------------------------------
func get_tournament_competitors(color_tier : String):
	var npc_decks_gd = preload("res://_scripts/npc_decks.gd").new()
	var pool_of_npcs : Array = npc_decks_gd.list_of_decks.keys()
	var prohibited_duelists = ["darkness"]
	
	#Remove some unwanted duelists from the tournament
	for prohibited in prohibited_duelists:
		pool_of_npcs.erase(prohibited)
	
	match color_tier:
		"green":
			#Pick 15 of the available NPCs as initial opponents for the tournament
			for _i in range(15):
				randomize()
				var random_npc_id = randi()%pool_of_npcs.size()
				tournament_competitors.append(pool_of_npcs[random_npc_id])
				pool_of_npcs.remove(random_npc_id)
			
			#Also add the player to the list and shuffle it
			tournament_competitors.append("player")
			randomize()
			tournament_competitors.shuffle()
		
		"blue", "purple", "red", "gold":
			#Pick 2^color_index of the previous (NPCs + player)
			var color_index = ["gold", "red", "purple", "blue"].find(color_tier)
			
			var selected_for_next_tier : Array = []
			for _i in range(pow(2, color_index)):
				var duelist_0 = tournament_competitors[0]
				var duelist_1 = tournament_competitors[1]
				
				var random_winner : String
				if not duelist_0 == "player" and not duelist_1 == "player":
					randomize()
					random_winner = tournament_competitors[randi()%2] #0 or 1
				else:
					random_winner = "player"
				
				selected_for_next_tier.append(random_winner)
				tournament_competitors.pop_front() #remove 0
				tournament_competitors.pop_front() #remove 1 that is now 0
			
			#Pass the selected ones as the global variable
			tournament_competitors = selected_for_next_tier
	
	#print(tournament_competitors)
	return tournament_competitors #global variable on this script

func update_duelist_boxes(box_color : String, list_of_duelists : Array):
	#Update the duelist faces on the 'box_color' tier
	for i in range(list_of_duelists.size()):
		var duelist_face_node = get_node("tournament_brackets/duelists_faces/" + box_color + "/face" + String(i+1))
		duelist_face_node.texture = load("res://_resources/character_faces/" + list_of_duelists[i] + "0.png")
	
	#Black out the tiers above it, grey out the losers bellow it
	var tier_colors = ["green", "blue", "purple", "red", "gold"]
	
	#Black out tiers above
	for i in range(tier_colors.find(box_color) + 1, tier_colors.size()):
		var color_to_black_out = tier_colors[i]
		for j in range(get_node("tournament_brackets/duelists_faces/" + color_to_black_out).get_child_count()):
			get_node("tournament_brackets/duelists_faces/" + color_to_black_out).get_child(j).texture = null
	
	#Grey out the previous tier losers
	var previous_tier = tier_colors[tier_colors.find(box_color) - 1]
	if previous_tier != "gold":
		for duelist_face in get_node("tournament_brackets/duelists_faces/" + previous_tier).get_children():
			var duelist_name = duelist_face.texture.resource_path.split("/")[-1].trim_suffix("0.png")
			if not duelist_name in list_of_duelists:
				duelist_face.self_modulate = Color(1,1,1, 0.3)

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

func get_opponent_name():
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
var debug_clicks = 0
func _on_dialogue_scene_dialogue_box_clicked():
#	if debug_clicks < 4:
#		var tier_colors = ["green", "blue", "purple", "red", "gold"]
#		update_duelist_boxes(tier_colors[debug_clicks+1], get_tournament_competitors(tier_colors[debug_clicks+1]))
#		debug_clicks += 1
	
	tournament_flow()

func tournament_flow():
	#First message
	if tournament_progression.size() == 0:
		var dialogue_to_show = $dialogue_scene.get_dialog("roland", "tournament_1")
		$dialogue_scene.update_screen_dialog(dialogue_to_show[0], dialogue_to_show[1])
		tournament_progression.append("tournament_1")
		
		return #escape to not glitch with rest of the function
	
	#All the next messages
	match tournament_progression[-1]: #always look for the LAST showed message
		"tournament_1": #show the message after this one
			var dialogue_to_show = $dialogue_scene.get_dialog("roland", "tournament_2")
			$dialogue_scene.update_screen_dialog(dialogue_to_show[0], dialogue_to_show[1])
			tournament_progression.append("tournament_2")
		"tournament_2":#show the message after this one
			var dialogue_to_show = $dialogue_scene.get_dialog("roland", "tournament_3")
			$dialogue_scene.update_screen_dialog(dialogue_to_show[0], dialogue_to_show[1])
			tournament_progression.append("tournament_3")
		"tournament_3":
			$dialogue_scene.empty_dialog_box()
			toggle_tournament_brackets_visibility()
			
			var dialogue_to_show = $dialogue_scene.get_dialog("roland", "tournament_green_tier")
			$dialogue_scene.update_screen_dialog(dialogue_to_show[0], dialogue_to_show[1], true)
			tournament_progression.append("tournament_green_tier")
		
		"tournament_green_tier":
			#Get the opponent's name and use it to show the correct picure, dialogue and start the duel
			var opponent_name = get_opponent_name()
			
			toggle_tournament_brackets_visibility()
			yield(get_tree().create_timer(0.2), "timeout")
			
			var dialogue_to_show = $dialogue_scene.get_dialog("generic", "pre_duel")
			$dialogue_scene.update_screen_dialog(opponent_name, dialogue_to_show[1])
			tournament_progression.append("green_tier_duel")
		
		_:
			print(tournament_progression)



