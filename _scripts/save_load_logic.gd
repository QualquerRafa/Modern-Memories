extends Node

var save_key = "permittedmemories123"

func save_game():
	#Get from 'PlayerData' the info that will be stored in a savefile
	var info_to_save = {
		#Player information
		"player_name"  : PlayerData.player_name, #String
		"player_deck"  : PlayerData.player_deck, #Array
		"player_trunk" : PlayerData.player_trunk, #Dictionary
		"player_starchips" : PlayerData.player_starchips, #Int
		"password_bought_cards" : PlayerData.password_bought_cards, #Array
		"recorded_duels" : PlayerData.recorded_duels, #Dictionary
		"last_reward_cards" : PlayerData.last_reward_cards, #Array
		"list_of_player_decks" : PlayerData.list_of_player_decks, #Dictionary
		"active_deck_name" : PlayerData.active_deck_name, #String
		"registered_freeduel_speed" : PlayerData.registered_freeduel_speed, #Float
		
		#Story Progression information
		"recorded_campaign_defeats" : PlayerData.recorded_campaign_defeats, #Array
		"recorded_dialogs" : PlayerData.recorded_dialogs, #Array
	}
	
	#Start the file to be written
	var save_file = File.new()
	#save_file.open_encrypted_with_pass("user://savegame.save", File.WRITE, save_key) #ENCRYPTED
	save_file.open_encrypted_with_pass("user://savegame.save", File.WRITE, OS.get_unique_id()) #ENCRYPTED
	
	#Write info to save_file
	save_file.store_line(to_json(info_to_save)) #get 'info_to_save' dictionary and turn into JSON
	save_file.close()
	
	return "sucess"

func load_game():
	#Check if a savegame exists, if not, scape function
	var save_file = File.new()
	if not save_file.file_exists("user://savegame.save"):
		return
	
	#for keys in [save_key, OS.get_unique_id()]:
	#	var get = save_file.open_encrypted_with_pass("user://savegame.save", File.READ, keys) #ENCRYPTED
	#	if get != null:
	#		break
	
	save_file.open_encrypted_with_pass("user://savegame.save", File.READ, OS.get_unique_id()) #ENCRYPTED
	
	var info_to_load = { } #start as empty dictionary and will be loaded key by key
	info_to_load = parse_json(save_file.get_as_text())
	
	#Load it safely. IF the save file has that information, load it. Good for future-proof with backwards compatibility
	var saved_info = [
		["player_name", "string"],
		["player_deck", "array"],
		["player_trunk", "dictionary"],
		["player_starchips", "int"],
		["password_bought_cards", "array"],
		["recorded_duels", "dictionary"],
		["last_reward_cards", "array"],
		["list_of_player_decks", "dictionary"],
		["active_deck_name", "string"],
		["registered_freeduel_speed", "float"],
		["recorded_campaign_defeats", "array"],
		["recorded_dialogs", "array"],
	]
	
	#Safely create the player's first deck slot if the save doesn't have it
	if not info_to_load.has("list_of_player_decks"):
		info_to_load.list_of_player_decks = {"01022" : {
													"color":"1,1,1,1",
													"deck" : info_to_load.player_deck
														}
											}
		info_to_load.active_deck_name = "01022"
	
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
		else:
			print("savefile didnt have '", saved_info[i][0], "'. This is just a warning, no problem with it.")
	
	return "sucess"
